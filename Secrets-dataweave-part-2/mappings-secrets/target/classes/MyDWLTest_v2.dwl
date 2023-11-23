%dw 2.4
output application/json
var companyId ="my-company-id-1"

var contracts = payload.myContracts

fun isProvider(supplier,plantId) = supplier.recivingFacilities.id contains plantId
                                      
fun getSuppliersByPlant(plantId) = do{
                                    var suppliers = payload.myContracts 
                                        filter isProvider($,plantId)     
                                    ---
                                    suppliers groupBy ((item, index) -> 
                                        item.company.id
                                    ) pluck ((value, key, index) -> 
                                        {
                                            name: value[0].company.name,
                                            id: value[0].company.id,
                                            locations: value.location
                                        })                                
                                    }

fun getPlants() = flatten(payload.myContracts.recivingFacilities) 
                    distinctBy ((item, index) -> item.id)
                        filter ((item, index) -> item.companyId == companyId)
                            map ((item, index) -> {
                                name: item.name,
                                id: item.companyId,
                                suppliers: getSuppliersByPlant(item.id)
                            })
---
{
  product: payload.name,
  plants: getPlants()
}