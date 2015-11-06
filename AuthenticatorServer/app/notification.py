from apns import APNs, Frame, Payload
import time

def send_notification(token_hex, one_time_code):
	print("SENDING NOTIF: {} {}".format(token_hex, one_time_code))
	apns = APNs(use_sandbox=True, cert_file='auth_cert.pem', key_file='auth_key.pem')

	
	payload = Payload(alert="Does {} appear on your screen?".format(one_time_code), sound="default", badge=1, custom={'code': one_time_code})
	apns.gateway_server.send_notification(token_hex, payload)