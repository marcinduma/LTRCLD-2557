# ACI to Public Cloud object mapping 

Cloud Network Controller is using cloud native objects to map ACI polices inside various public clouds. 

Before we go into logical object configuration, let's spend a minute to explore how ACI Policies will be mapped to native Cloud objects. Whenever we push an ACI Policy(directly fron CNC or via NDO), CNC based on the diagrams below will use Public Cloud API and configure respective object in respective clouds. 

## ACI to AWS object mapping 

Below you can find how ACI policy model is mapped to AWS cloud native objects 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/aws_object_mapping.png" width = 1000>


## ACI to Azure object mapping 

Below you can find how ACI policy model is mapped to Azure cloud native objects 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/azure_object_mapping.png" width = 1000>