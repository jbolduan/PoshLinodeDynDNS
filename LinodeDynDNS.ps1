# ResourceID can be obtained by going to DNS Manager > Edit Domain > Edit A/AAAA
# Then, grab the URL and it should be formatted like this
# https://manager.linode.com/dns/resource/domain%2Ecom?id=00000000
$Resource = "00000000"

# DomainID can be obtained by going to DNS Manager > Domain Zone File
# Then, right next to your domain name there should be a number in brackets
# ; domain.com [00000000]
$Domain = "00000000"

# Generate an API key for Linode in your profile
$Key = "yourapikeyshouldbehere"

# I'm using icanhazip and IPv4
$GetIP = "http://ipv4.icanhazip.com/"

$GetResponse = Invoke-RestMethod -Uri "https://api.linode.com/?api_key=$key&api_action=domain.resource.list&DomainID=$Domain&ResourceID=$Resource"
$IPv4Address = Invoke-WebRequest -Uri "http://ipv4.icanhazip.com"

if($IPv4Address.Content.TrimEnd() -eq $GetResponse.Data.TARGET) {
	
} else {
	$UpdateResponse = Invoke-WebRequest -Uri "https://api.linode.com/?api_key=$key&api_action=domain.resource.update&DomainID=$Domain&ResourceID=$Resource&Target=$($IPv4Address.Content.TrimEnd())"
	$UpdateResponseJson = $UpdateResponse.Content | ConvertFrom-Json
	if($UpdateResponseJson.ErrorArray.ErrorCode -ne 0) {
		exit $UpdateResponseJson.ErrorArray.ErrorCode
	}
}