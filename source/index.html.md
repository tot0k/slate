---
title: MONDB API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - curl

toc_footers:
  - <a href='#'>Sign Up</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the MONDB API! You can use our API to access MONDB API endpoints, which can get information about Foods, Nutrient Reference Values, Physical activities and Nutrition Guidelines.
The goal of MONDB is to provide a knowledge base about nutrition in a standardized way. We regrouped and parsed databases from allover the world, so you can query them the same way everytime.

The API is splitted in 4 parts : 

* **FCDB** : Food Composition
* **NRVDB** : Nutrient Reference Values
* **CPADB** : Compendium of Physical Activities
* **DNRDB** : Diaries and Nutrition Research data

You can view code examples in the dark area to the right.

# Response format

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food/"
  --request GET
    -H "type: json"
```

> The above command returns JSON structured like this

```json
  {
       "success": true,
       "response": [
           {
               "dataset": "ciqual-2017v1",
               "results": 2807
           },
           {
               "dataset": "example-2018",
               "results": 2
           },
           {
               "dataset": "test",
               "results": 91
           }
       ]
   }
```

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food/"
  --request GET
    -H "type: xml"
```

> The above command returns XML structured like this

```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <xml>
      <success>true</success>
      <response>
          <object>
              <dataset>ciqual-2017v1</dataset>
              <results>2807</results>
          </object>
          <object>
              <dataset>example-2018</dataset>
              <results>2</results>
          </object>
          <object>
              <dataset>test</dataset>
              <results>91</results>
          </object>
      </response>
  </xml>
```

The response is always structured with a `success` boolean, and the response.
You can specify the format of data you want to be returned.
You can choose between

* JSON
* XML

Example : 
`GET fcdb/food/?type=json` will return you a JSON object
`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food/?type=xml` will return you a XML object

<aside class="notice">
The default return type is JSON
</aside>

If the response is an error, it will have an API error `id`, a `description` and a `message`, to help you correct your request.

> Architecture of an API error in JSON

```json
    {
        "success": false,
        "error": {
            "id": 2,
            "description": "Not found",
            "message": "Unknown ressource"
        }
    }
```

> Architecture of an API error in XML

```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <xml>
        <success>false</success>
        <error>
            <id>2</id>
            <description>Not found</description>
            <message>Unknown ressource</message>
        </error>
    </xml>
```

# URL Parameters

In each request, you can specify how many elements you want to be returned, and the index of the first element returned.

> To query 2 foods, starting at index 1000 of request, use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food/"
  --request GET
    -H "start: 1000"
    -H "count: 2"
    -H "db: ciqual-2017v1"
```

> The above command returns JSON structured like this

```json
{
    "success": true,
    "start": 1000,
    "end": 1001,
    "total": 2807,
    "response": [
        {
            "database_name": "ciqual-2017v1",
            "id": "dvo4u91696solknmnq0ju06dthb9d7jp",
            "name": "Almond oil",
            "group": {
                "id": "h6s6ia6jfv3xit28pfirb0dmh3nruy9t",
                "name": "vegetable oils",
                "parent": {
                    "id": "5ehwkax1opelveomxtcyery1az35qzxo",
                    "name": "fats and oils"
                }
            },
            "description": "Almond oil"
        },
        {
            ...
        }
    ]
}
```

If a matches with many elements, it returns by default only the 10 first. You can change this number by adding the parameter `count`.
You can also change the index of the first element returned by adding the parameter `start`.

Example : `GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food/?start=1000&count=2&db=ciqual-2017v1`

# Authentication

The Auth process is based on JWT tokens.

> To retrieve your token, use this code:

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/dnrdb/token/"
  --request GET
    -H "email: <yourEmail>"
    -H "password: <yourPassword>"
```

`GET http://farmit.massey.ac.nz/~mondb/api/dnrdb/token/?email="your@email.com&password="yourStrongPassword"`

> The above command returns JSON structured like this

```json
{
    "success": true,
    "response": {
        "token": "Your.JWT.Token",
        "exp": 1536807587
    }
}
```
<aside class="notice">
The `exp` value is the expirency timestamp of the token. When a request fails, check if the token is still valid !
</aside>

You must [register](http://farmit.massey.ac.nz/~mondb/index.php?routing=register) to be able to retrieve a token.

# FCDB

The FCDB database contains information about foods and meals.

You do not need to provide a Auth token to access any of these data

A basic request to the FCDB database :

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/<dataType>/<parameter>/<value>?<URL Parameters>&db=<dataset>`

## Dataset
When we add information from a database, we add them in a new dataset, which stores only data from the same source (eg : Ciqual French Open Data, or New Zealand Data).
To have a list of the different datasets, use this request

> To get the list of the different datasets use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food"
```

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food`

> The above command returns JSON structured like this

```json
  {
       "success": true,
       "response": [
           {
               "dataset": "ciqual-2017v1",
               "results": 2807
           },
           {
               "dataset": "example-2018",
               "results": 2
           },
           {
               "dataset": "test",
               "results": 91
           }
       ]
   }
```

The `results` number is the amount of foods stored in the dataset.

After choosing the dataset, you just have to do the same request, with the name of the dataset precised in argument.
`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food?db=ciqual-2017v1`

```curl
"http://farmit.massey.ac.nz/~mondb/api/fcdb/food"
  --request GET
  -H "db: ciqual2017-v1"
```

## Data Type
Data Type | Utility
--------- | -----------
component | Information about specific components (name, unit, etc).
food | Information about the food (name, description, group).
meal | Information about the meal (name, description, group).
foodComposition | Stores the composition of each food.
source | Stores the provenance of each information.
unit | Stores the relations between the different units in the different datasets, so you can easily switch from one unit to the other.
foodGroup | Regroups the foods by type
mealGroup | Regroups the meals by type
componentGroup | Regroups the components by family, to link them between the different datasets


The `<dataset>` section is here to specify in which database you want to do your query (The French Database ? The New Zealand one ?)

## Parameter / Value
> Example of a request for a food named "Chocapic" in the French database

```curl
"http://farmit.massey.ac.nz/~mondb/api/fcdb/food/name/Chocapic"
  --request GET
  -H "db: ciqual2017-v1"
```

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food/name/Chocapic?db=ciqual-2017v1`

> The above command returns JSON structured like this

```json
{
    "success": true,
    "start": 1,
    "end": 1,
    "total": 1,
    "response": {
        "database_name": "ciqual-2017v1",
        "id": "f2dqt120dub7kidv0vefm0qkdgx0f766",
        "name": "Chocapic",
        "group": {
            "id": "f55tk78z7ls962vyyaqh66qmxsfk4p84",
            "name": "breakfast cereals",
            "parent": {
                "id": "2x0tuj9wgaz3g05m9h74mpdj8e6aod74",
                "name": "biscuits and breakfast cereals",
                "parent": {
                    "id": "d2f6lgk2jwklpvkeemvu1n4hs5588bgz",
                    "name": "cereal products"
                }
            }
        },
        "description": "Breakfast cereals, with chocolate, not filled, fortified with vitamins and chemical elements"
    }
}
```

Every element of the datasets files has an `id` and a `name` you can use to do simple research. They are some others default parameters, depending of the data type

Data Type | Default Parameters
--------- | -----------
component | grp_id
food | description, grp_id
meal | description, grp_id
foodComposition | value, unit_id, trust_code, source_id
source | 
unit | numerator, denominator, factor
foodGroup | parent_id
mealGroup | parent_id
componentGroup | parent_id


## URL Parameters
You may want to add additional arguments to your research. For each request, you can add the following arguments and all the arguments of the [URL Parameters](#url-parameters) section.

### db
> To query the food of the dataset `ciqual-2017v1` use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food/"
  --request GET
    -H "db: ciqual-2017v1"
```

As said before, you may precise in which dataset you want to do your query.
Just add the `db` parameter to precise in which dataset you want to do it.

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food?db=ciqual-2017v1`


### Query
> Example of a query with additional parameters

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/food/grp_id/12345"
  --request GET
    -H "db: dataset"
    -H "query: parameter1=value1,parameter2<value2"
```

You can add additional query information about the parameters of the resource you are querying.

You can use the following operators

* =
* !=
* <
* \>

You must separate the fields by comma (`,`).

Example : 

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/food/grp_id/12345/?db=dataset&query=parameter1=value1,parameter2<value2`

### Type
Refer to the [Response Format](#response-format) section.

## Search
You can search for a word or group of words in the name and description of foods with the following command.

> To get the list of the different resources use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/fcdb/search"
  --request GET
    -H "db: dataset"
    -H "search: "The String you are searching for"
```

`GET http://farmit.massey.ac.nz/~mondb/api/fcdb/search?db=ciqual-2017v1&search=pain`

> The above command returns JSON structured like this

```json
  {
      "success": true,
      "start": 1,
      "end": 10,
      "total": 52,
      "response": [
          {
              "id": "mitruwprv5rjmheqyprzffwo4dl2z2ov",
              "name": "Pain panini"
          },
          {
              "id": "vtf6ldssrbra29g6soxogk8i94oe0cq6",
              "name": "Pain d'épices"
          },
          ...
      ]
  }
```

# NRVDB

# CPADB

The Compendium of Physical Activities DataBase contains `met` information about human activities.

## Resources

You can query the list of the resources available with the following command.

> To get the list of the different resources use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/cpadb"
```
`GET http://farmit.massey.ac.nz/~mondb/api/cpadb`

> The above command returns JSON structured like this

```json
  {
      "success": true,
      "response": [
          {
              "resource": "activity.xml",
              "results": 832
          },
          {
              "resource": "activityType.xml",
              "results": 22
          }
      ]
  }
```

## Activity

You can query the list of all the activities with the following command.

> To get the list of the different activities use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/cpadb/activity/"
```
`GET http://farmit.massey.ac.nz/~mondb/api/cpadb/activity/`

> The above command returns JSON structured like this

```json
  {
      "success": true,
      "start": 1,
      "end": 10,
      "total": 821,
      "response": [
          {
              "id": "usrsbfewr97dipch2rfl81cexhyk9s8i",
              "code": "01003",
              "description": "bicycling, mountain, uphill, vigorous",
              "met": "14",
              "type": {
                  "id": "7asnmi575n05hb6mog0gfzrs0huic8va",
                  "code": "01",
                  "name": "bicycling"
              }
          },
          ...
          }
      ]
  }
```

<aside class="notice">
You can use the `count` and `start` parameters to query a specific part of the list
</aside>

<aside class="notice">
You can use the `type` parameter to change the response type (XML / JSON)
</aside>

## Activity Type

You can query the list of all the activity types with the following command.

> To get the list of the different activity types use this code

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/cpadb/activityType/"
```
`GET http://farmit.massey.ac.nz/~mondb/api/cpadb/activityType/`

> The above command returns JSON structured like this

```json
  {
      "success": true,
      "start": 1,
      "end": 10,
      "total": 21,
      "response": [
          {
              "id": "7asnmi575n05hb6mog0gfzrs0huic8va",
              "code": "01",
              "name": "bicycling"
          },
          ...
      ]
  }
```

<aside class="notice">
You can use the `count` and `start` parameters to query a specific part of the list
</aside>

<aside class="notice">
You can use the `type` parameter to change the response type (XML / JSON)
</aside>

## Parameter / Value

They are some others default parameters, depending of the resource

Data Type | Default Parameters
--------- | -----------
activity | id, code, description, met, type_id
activity Type | id, code, name

###Example

To query the list of the activities that are about bicycling, you need to do 2 requests :

> To query the activityType which name is "bicycling do the following command"

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/cpadb/activityType/name/bicycling"
```
> The above command returns JSON structured like this

```json
  {
      "success": true,
      "start": 1,
      "end": 1,
      "total": 1,
      "response": [
          {
              "id": "7asnmi575n05hb6mog0gfzrs0huic8va",
              "code": "01",
              "name": "bicycling"
          }
      ]
  }
```

`GET http://farmit.massey.ac.nz/~mondb/api/cpadb/activityType/name/bicycling`
To query the id of the type bicycling

> To query the activities about "bicycling", do the following command

```curl
curl "http://farmit.massey.ac.nz/~mondb/api/cpadb/activity/type_id/7asnmi575n05hb6mog0gfzrs0huic8va"
```
> The above command returns JSON structured like this

```json
  {
      "success": true,
      "start": 1,
      "end": 10,
      "total": 18,
      "response": [
          {
              "id": "usrsbfewr97dipch2rfl81cexhyk9s8i",
              "code": "01003",
              "description": "bicycling, mountain, uphill, vigorous",
              "met": "14",
              "type": {
                  "id": "7asnmi575n05hb6mog0gfzrs0huic8va",
                  "code": "01",
                  "name": "bicycling"
              }
          },
          ...
      ]
  }
```

`GET http://farmit.massey.ac.nz/~mondb/api/cpadb/activity/type_id/httdhjtsums9z477kd927wy2kx25ge3x`
To query list of activities that have this type_id


<aside class="notice">
You can use the `count` and `start` parameters to query a specific part of the list
</aside>

<aside class="notice">
You can use the `type` parameter to change the response type (XML / JSON)
</aside>

# DNRDB