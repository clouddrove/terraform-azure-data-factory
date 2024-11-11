## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application | Application (e.g. `cd` or `clouddrove`). | `string` | `""` | no |
| cmk\_encryption\_enabled | n/a | `bool` | `false` | no |
| create | Used when creating the Resource Group. | `string` | `"60m"` | no |
| delete | Used when deleting the Resource Group. | `string` | `"60m"` | no |
| enable\_private\_endpoint | enable or disable private endpoint to storage account | `bool` | `false` | no |
| enabled | Flag to control the module creation. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| existing\_private\_dns\_zone | Name of the existing private DNS zone | `string` | `null` | no |
| existing\_private\_dns\_zone\_resource\_group\_name | The name of the existing resource group | `string` | `""` | no |
| identity\_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. | `list(string)` | `null` | no |
| identity\_type | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"SystemAssigned"` | no |
| key\_vault\_id | n/a | `string` | `null` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| location | Location where resource should be created. | `string` | `""` | no |
| machine\_count | Number of Virtual Machines to create. | `number` | `0` | no |
| managed\_virtual\_network\_enabled | Is default virtual machine enabled for data factory or not. | `bool` | `null` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | `string` | `"anmol@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| principal\_id | The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| private\_dns\_zone\_name | The name of the private dns zone name which will used to create private endpoint link. | `string` | `"privatelink.blob.core.windows.net"` | no |
| public\_network\_enabled | Is the Data Factory visible to the public network? Defaults to true. | `bool` | `false` | no |
| read | Used when retrieving the Resource Group. | `string` | `"5m"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_name | The name of the resource group in which to create the virtual network. | `string` | `""` | no |
| shared\_access\_key\_enabled | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true. | `bool` | `true` | no |
| subnet\_id | The resource ID of the subnet | `string` | `""` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| update | Used when updating the Resource Group. | `string` | `"60m"` | no |
| virtual\_network\_id | The name of the virtual network | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| identity | n/a |

