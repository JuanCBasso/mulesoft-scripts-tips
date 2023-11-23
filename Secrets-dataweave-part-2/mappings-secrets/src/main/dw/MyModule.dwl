/**
* This module will be shared through your library, feel free to modify it as you please.
*
* You can try it out with the mapping on the src/test/dw directory.
*/
%dw 2.0
var myCompanyId='my-company-id-1'

fun translateSupplier(supplier) = do {
                                    var locations = (supplier.location)
                                    ---
                                    {
                                        name: supplier[0].company.name,
                                        id: supplier[0].company.id,
                                        locations: locations
                                    }
                                    }

fun findSuppliersByPlant(productSpecification, plantId) = (productSpecification.myContracts 
                                                                filter ((item, index) -> 
                                                                    item.recivingFacilities.id contains plantId) 
                                                                    groupBy ((item, index) -> item.company.id))
                                                                        pluck ((value, key, index) -> translateSupplier(value) )
                                                                    
fun extractMyReceivingPlants(productSpecification) = (
                                                      flatten(productSpecification..recivingFacilities) 
                                                        filter ((item, index) -> item.companyId == myCompanyId)
                                                        ) 
                                                        distinctBy ((item, index) -> item.id) 
                                                            orderBy ((value, key) -> value.id)

fun transformContracts(productSpecification) = do
                            {
                                var myReceivingPlants = extractMyReceivingPlants(productSpecification)
                                ---
                                {
                                    product: productSpecification.name,
                                    plants: myReceivingPlants map ((plant, index) -> 
                                        plant - 'companyId' ++ {
                                            suppliers: findSuppliersByPlant(productSpecification,plant.id)
                                        }
                                    )
                                }
                            }