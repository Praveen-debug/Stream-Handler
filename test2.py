from obswebsocket import obsws, requests



obs_client = obsws("192.168.1.43", 4444, "Iphonex")

obs_client.connect()

response = obs_client.call(requests.GetStreamingStatus())

print(response)

