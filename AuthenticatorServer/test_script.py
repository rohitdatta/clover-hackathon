import requests

def valid_test():
	with requests.Session() as s:
	    code = s.post('http://localhost:5000/login/get_code', data=dict(username="test_user")).text
	    s.post('http://localhost:5000/login/register', data=dict(username="test_user", uuid="test_uuid", one_time_code=code, push_key="magic_push_key"))
	    code = s.post('http://localhost:5000/login/get_code', data=dict(username="test_user")).text
	    s.post('http://localhost:5000/login/auth', data=dict(username="test_user", uuid="test_uuid", one_time_code=code))
	    s.post('http://localhost:5000/login/get_cookie', data=dict(username="test_user", one_time_code=code))
	    result = s.get('http://localhost:5000/login/test').text
	    return result == "True"

def invalid_register_test():
	with requests.Session() as s:
	    code = s.post('http://localhost:5000/login/get_code', data=dict(username="test_user")).text
	    s.post('http://localhost:5000/login/register', data=dict(username="test_user", uuid="test_uuid", one_time_code="wrong code lmao", push_key="magic_push_key"))
	    code = s.post('http://localhost:5000/login/get_code', data=dict(username="test_user")).text
	    s.post('http://localhost:5000/login/auth', data=dict(username="test_user", uuid="test_uuid", one_time_code=code))
	    s.post('http://localhost:5000/login/get_cookie', data=dict(username="test_user", one_time_code=code))
	    result = s.get('http://localhost:5000/login/test').text
	    return result == "True"

tests = [(valid_test, True), (invalid_register_test, False)]

for test, expected in tests:
	requests.get("http://localhost:5000/login/flush")
	print(test)
	assert test() == expected