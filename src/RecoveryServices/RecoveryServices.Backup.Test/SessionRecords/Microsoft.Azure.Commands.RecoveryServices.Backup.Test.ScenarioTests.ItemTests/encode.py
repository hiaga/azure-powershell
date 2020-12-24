import json
import base64

# Opening JSON file
f = open('TestAzureVMProtection.json',)

# returns JSON object as
# a dictionary
data = json.load(f)

# Iterating through the json
# list
with open("ATestAzureVMProtection.json", "w") as outfile:
    for i in data['Entries']:
        str = i["RequestUri"]
        if "2021-01-01" in str:
            uri = i["RequestUri"]
            message_bytes = uri.encode('ascii')
            base64_bytes = base64.b64encode(message_bytes)
            base64_message = base64_bytes.decode('ascii')
            print(base64_message)
            i["EncodedRequestUri"] = base64_message
            json.dump(i, outfile, indent = 2)
        else:
            json.dump(i, outfile, indent = 2)
        outfile.write(",\n")

# Closing file
f.close()