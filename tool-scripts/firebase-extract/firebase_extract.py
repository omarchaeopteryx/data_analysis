# Omar Malik. 2017.
import pyrebase
import requests
import json
import getpass

config = {
  "apiKey": "AIzaSyB95x1zEsSkXfaDgOVdTw7ESavk9O9geN0",
  "authDomain": "dowhop-lifecycle.firebaseapp.com",
  "databaseURL": "https://dowhop-lifecycle.firebaseio.com",
  "storageBucket": "dowhop-lifecycle.appspot.com",
}

firebase = pyrebase.initialize_app(config)

# Get a reference to the auth service:
auth = firebase.auth()

# Log the user in:
email = input('email:')
password = getpass.getpass('pass:')
user = auth.sign_in_with_email_and_password(email, password)
userIdToken = user['idToken'];

print(user['displayName'])
print(userIdToken)

r = requests.get(url='https://dowhop-lifecycle.firebaseio.com/.json?print=pretty&format=export&download=dowhop-lifecycle-export.json&auth=%s' % userIdToken)

allData = r.json()

with open('results.json', 'w') as outfile:
    json.dump(allData, outfile)
