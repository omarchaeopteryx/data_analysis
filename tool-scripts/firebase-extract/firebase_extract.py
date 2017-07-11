import pyrebase
import requests
import json

config = {
  "apiKey": "AIzaSyB95x1zEsSkXfaDgOVdTw7ESavk9O9geN0",
  "authDomain": "dowhop-lifecycle.firebaseapp.com",
  "databaseURL": "https://dowhop-lifecycle.firebaseio.com",
  "storageBucket": "dowhop-lifecycle.appspot.com",
}

firebase = pyrebase.initialize_app(config)

# Get a reference to the auth service
auth = firebase.auth()

# Log the user in

email = input('email:')
password = input('pass:')
user = auth.sign_in_with_email_and_password(email, password)
userIdToken = user['idToken'];

print(user['displayName'])
print(userIdToken)

r = requests.get(url='https://dowhop-lifecycle.firebaseio.com/.json?print=pretty&format=export&download=dowhop-lifecycle-export.json&auth=%s' % userIdToken)

allData = r.json()
# r = requests.get(url='https://dowhop-lifecycle.firebaseio.com/.json?print=pretty&format=export&download=dowhop-lifecycle-export.json&auth=nYiOjB9._9L0JojCMC8uKO-VOKjC-ddGqOFSXVms1D9eLiHbhWM')
# print(allData)

with open('results.txt', 'w') as outfile:
    json.dump(allData, outfile)
