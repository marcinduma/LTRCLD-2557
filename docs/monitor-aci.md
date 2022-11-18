# How to pull informations using REST API

The REST API is the interface into the management information tree (MIT) and allows manipulation of the object model state. The same REST interface is used by the APIC CLI, GUI, and SDK, so that whenever information is displayed, it is read through the REST API, and when configuration changes are made, they are written through the REST API. The REST API also provides an interface through which other information can be retrieved, including statistics, faults, and audit events. It even provides a means of subscribing to push-based event notification, so that when a change occurs in the MIT, an event can be sent through a web socket.

Standard REST methods are supported on the API, which includes POST, GET, and DELETE operations through HTTP. The GET method is nullipotent, meaning that it can be called zero or more times without making any changes (or that it is a read-only operation).

## 1. Creating the API Command

You can invoke an API command or query by sending an HTTP or HTTPS message to the APIC with a URI of this form for an operation on a managed object (MO):

{http | https}://host [:port] /api/mo/dn. {json | xml} [?options]

Use this form for an operation on an object class:

{http | https}://host [:port] /api/class/className. {json | xml} [?options]

!!!Note	
	While the preceding examples use **/api/mo** and **/api/class** in the URI string, the APIC UI and Visore also use the **/api/node/mo** and **/api/node/class** syntax in the URI string. Both formats are valid and are used interchangeably in this document.

This example shows a URI for an API operation that involves an MO of class fv:Tenant:

https://apic-ip-address/api/mo/uni/tn-ExampleCorp.xml


### 1.1 The URI for an API Operation on an MO

https://apic-ip-address/api/mo/uni/tn-ExampleCorp.xml

### 1.2 The URI for an API Operation on an Node MO

In an API operation to access an MO on a specific node device in the fabric, the resource path consists of ==**/mo/topology/pod-number/node-number/sys/**== followed by the node component. For example, to access a board sensor in chassis slot b of node-1 in pod-1, use this URI:

GET https://apic-ip-address/api/mo/topology/pod-1/node-1/sys/ch/bslot/board/sensor-3.json

### 1.3. The URI for an API Operation on a Class

In an API operation to get information about a class, the resource path consists of **/class/** followed by the name of the class as described in the Cisco APIC Management Information Model Reference. In the URI, the colon in the class name is removed. For example, this URI specifies a query on the class aaa:User:

GET https://apic-ip-address/api/class/aaaUser.json

## 2. Pulling data from created Tenant

In the restAPI section you created tenant called **"Postman-collection-1"**. That tenant have 22 EPGs and BDs and now you would like to pull data about one of them.

**POTENTIAL EXCERCISE:**

Server Team asked you to add new static binding for server addressed in subnet 172.16.59.0/24. You don't know what is name of EPG and now you have to do reverse engineering to find correct EPG.

You know that GW IP address of BD is 172.16.59.1/24. Your task is to find BD name using GET API query and by having BD, find name of EPG associated to it.

*Where to start?*

Think about how to find class-name of Bridge Domain. During the day you used few methods - "Save As" object, "Show Debug Info" in APIC, "API Inspector", "Open in Object Store Browser".
Choice method you prefer and find class-name for BD.

Once you have it, compose URL, Answer below:

		https://{{apic}}/api/class/fvBD.json

Create Postman Request to GET information from class-name you specify above.

Result should shows you "totalCount": "28" meaning you found 28 bridge domains and you listed their attributes. Still you are not able to find out the correct one.

Now list all sub-tree of object fvBD. Do it with adding KEY parameter to your GET query:

		https://{{apic}}/api/class/fvBD.json?query-target=subtree
		
You listed all Bridge Domains with all MIT for them, now results with more than 200 items in APIC response.

Having information about IP address of GW, you can narrow it to one, having that specific IP. Let's try:

		https://{{apic}}/api/class/fvBD.json?query-target=subtree&query-target-filter=and(wcard(fvSubnet.ip,"172.16.59.1/24"))
		
Function which contain IP addresses under BD is fvSubnet. The attribute of the function is ==**ip**==. By using filter **query-target-filter=and(wcard(fvSubnet.ip,"172.16.59.1/24"))** you get information about DN of function. The DN contains Bridge-Domain name.

Results on the figure below:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/get-bd-ipaddress.png" width = 800>

Please list informations about Bridge Domain you found: **BD-59**.

		https://{{apic}}/api/class/fvBD.json?query-target=subtree&query-target-filter=and(eq(fvBD.name,"BD-59"))

Still you don't have EPG name. Why you don't see sub-tree of the fvBD in your GET response??

You need to specify RSP-SUBTREE in your GET. 

		https://{{apic}}/api/class/fvBD.json?query-target=subtree&rsp-subtree=full&query-target-filter=and(eq(fvBD.name,"BD-59"))

In the output you should look for **fvRtBd** class-name. It contains information about EPG to BD relation. Now try yourself to narrow down the output.


		https://{{apic}}/api/class/fvRtBd.json?query-target=subtree&query-target-filter=and(wcard(fvRtBd.dn,"BD-59"))
		
Using URL above you are able to filter response from APIC for class-name fvRtBd and DN path which contain BD-59 in.


```json title="fvRtBd.dn" hl_lines="5"
{
"fvRtBd": {
"attributes": {
"childAction": "",
"dn": "uni/tn-Postman-collection-1/BD-BD-59/rtbd-[uni/tn-Postman-collection-1/ap-APPLICATION-PROFILE-1/epg-EPG-59]",
"lcOwn": "local",
"modTs": "2022-11-04T18:22:39.217+00:00",
"status": "",
"tCl": "fvAEPg",
"tDn": "uni/tn-Postman-collection-1/ap-APPLICATION-PROFILE-1/epg-EPG-59"
}
}
}
```

### <p style="text-align: center;"> ^^CONGRATULATIONS^^, you found correct EPG:  **EPG-59** </p>


## <p style="text-align: center;"> Please see the ==[Collection of REST API URLs](URL-restAPI.md)== for further details. </p>

