
<!DOCTYPE html>
<html lang="en">
<head>
<title>Authenticator Project 2B </title>
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<meta name="apple-mobile-web-app-capable" content="yes">   
<link rel="stylesheet" 
href="https://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.css" /> 
<script src="https://code.jquery.com/jquery-1.9.1.min.js"></script> 
<script src="https://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.js"></script> 
</head>


<?php
session_start();
session_destroy();
?>

<body onload="form.reset();">

  <form name="form" action="cregisterdata.php" method="post">
  
		<div data-role="page" id=pageone> 
			<div data-role="header"> 
				<h1>Authenticator Project 2B </h1> 
			</div><!-- /header --> 
		<div data-role="content"> 
		<table width="1000" border="20" align="center" cellpadding="20" cellspacing="1" bgcolor="black"> <tr> <td>
		<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="white"> 
			<tr>
			</tr>
			<tr>
			</tr>
			<tr>
			<td> <input type="submit" name="Login" value="Login">
			<input type="submit" name="Register" value="Register"></td>
			</tr>
			</tr> </td>
		</table>
		</table>
		</div>
	</form>
		
		   
 
	<div data-role="footer" data-position="fixed"> 
		<p>Michelle, Jeffrey, Sam, Jose, Rohit</p> 
	</div><!-- /footer --> 
	 
</body> 
</html>  
