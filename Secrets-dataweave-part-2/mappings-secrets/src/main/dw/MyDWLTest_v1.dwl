%dw 2.4
output application/json

var companyId ="my-company-id-1"

var contracts = payload.myContracts

fun extractSuppliersLocations(supplier) = do
                                        {
                                            var extractedLocations = contracts
                                            ---
                                            supplier.location
                                        }

fun transformSupplier(supplier) = {
 id: supplier.id,
 name: supplier.name,
 locations: extractSuppliersLocations(supplier)
}

fun extractSuppliersByPlant(plantId) = ((contracts) filter 
                                        ((item, index) -> 
                                            ((item).recivingFacilities.id contains plantId))) 
                                                map transformSupplier($)


fun transformPlant(plant) = {
    id: plant.id,
    name: plant.name,    
    address : plant.address,
    suppliers: extractSuppliersByPlant(plant.id)
}

fun extractPlants() = flatten(contracts..recivingFacilities) 
                                filter $.companyId == companyId
                                  distinctBy $.id
                                    map transformPlant($)
                                 
---
{
  product: payload.name,
  plants: extractPlants()
  /*[
    {
      "name": "My plant 1",
      "id": "plant-1",
      "address": "Mitre 3340, Bahia Blanca, Buenos Aires, Argentina ",
      "suppliers": [
        {
          "name": "The Corn Company",
          "id": "company-1",
          "locations": [
            {
              "name": "The Corn Company - Location 1",
              "id": "company-location-1",
              "address": "Alem 856, Trelew, Chubut, Argentina"
            }
          ]
        },
        {
          "name": "The West Corn Company",
          "id": "company-3",
          "locations": [
            {
              "name": "The West Corn Company - LA 1",
              "id": "company-location-3",
              "address": "523 Meadow Grove Street, Los Angeles County, California, USA"
            }
          ]
        }
      ]
    }
  ]*/
}