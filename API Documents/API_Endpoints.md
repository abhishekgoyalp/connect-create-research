
# API Endpoints

**Author:** Jitendra Panwar  

## Table of Contents
1. [Create User Profile](#create-user-profile)
2. [Get the List of User Profiles](#get-the-list-of-user-profiles)
   - [Backend Flow](#backend-flow)
3. [View User’s full Profile](#view-users-full-profile)

---

## Create User Profile
Saves the user record into the database.

**API Endpoint:** `/v1/users`  
**Method:** `POST`  

### HTTP Body
```json
{
  "firstName": "Alex",
  "lastName": "Smith",
  "phoneNumber": "123456789",
  "currentAddress": {
    "region": "Tilak Nagar",
    "city": "Delhi",
    "state": "Delhi",
    "addressType": "current"
  },
  "homeAddress": {
    "region": "Mansarovar",
    "city": "Jaipur",
    "state": "Rajasthan",
    "addressType": "home"
  }
}
```

---

## Get the List of User Profiles
Returns the list of users by applying the current city and hometown city filters.

**API Endpoint:** `/v1/users`  
**Method:** `GET`  
**Parameters:** `currentCity=Bangalore&hometownCity=Lucknow`  

### Sample Response
```json
{
  "users": [
    {
      "id": 201,
      "firstName": "Priya",
      "lastName": "Singh",
      "currentCity": "Bangalore",
      "hometownCity": "Lucknow"
    },
    {
      "id": 202,
      "firstName": "Arjun",
      "lastName": "Yadav",
      "currentCity": "Bangalore",
      "hometownCity": "Lucknow"
    }
  ]
}
```

### Backend Flow
1. Extract `currentCity` and `hometownCity` from query params.  
2. Look up their IDs in the `cities` table:  

```sql
SELECT id FROM cities WHERE name = :currentCity;
SELECT id FROM cities WHERE name = :hometownCity;
```

3. Use those IDs to filter users in the `users` table:  

```sql
SELECT u.id, u.firstName, u.lastName, 
       cc.city AS current_city, 
       hc.city AS hometown_city
FROM users u
JOIN cities cc ON u.current_city_id = cc.id
JOIN cities hc ON u.hometown_city_id = hc.id
WHERE cc.name ILIKE :currentCity 
  AND hc.name ILIKE :hometownCity;
```

---

## View User’s full Profile
Returns the user’s full information, including their phone number and complete home address (including the region).

---
