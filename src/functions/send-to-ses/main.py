import boto3
import json

client = boto3.client("ses")
email = "growth@datastack.de"

def send_email(event):
    return client.send_email(
            Source= email,
            Destination={
                    "ToAddresses": [
                            "growth@datastack.de" ]},
                    Message={
                            "Subject": {
                                    "Data": "New lead on datastack.de",
                                    "Charset": "utf-8"
                                    },
                            "Body": {
                                    "Text": {
                                            "Data": "Here is the content of the message: " + json.dumps(event),
                                            "Charset": "utf-8"
                                            }
                                    }
                            },
                    ReplyToAddresses=[
                            "growth@datastack.de"
                            ]
                    )

def clean(x):
    entry = x.get("dynamodb").get("NewImage")
    first_name = entry.get("firstName").get("S")
    email = entry.get("email").get("S")
    window_location = entry.get("windowLocation").get("S")
    form = entry.get("form").get("S")
    return {
            "first_name": first_name, 
            "email": email, 
            "window_location": window_location, 
            "form":form
            }


def process(event):
    records = event["Records"]
    data = [clean(x) for x in records]
    return data

def handler(event, ctx):
    return send_email(process(event))


if __name__ == "__main__":

    with open("./payload.json") as file:
        try:
            event = json.load(file)
            res = handler(event, None)
            print(res)
        except Exception as e:
            print(e)
