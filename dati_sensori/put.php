<?php
$con = mysqli_connect('localhost', 'progettomiotto', '', 'my_progettomiotto');

$temperature = $_GET['temperature'];
$humidity = $_GET['humidity'];
$humidity_ter = $_GET['humidity_ter'];
$luminosity = $_GET['luminosity'];
$type = $_GET['type'];
$value = $_GET['value'];

if(isset($temperature)&&isset($humidity)&&isset($humidity_ter)&&isset($luminosity)){
	if($temperature=='nan'||$humidity=='nan'||$humidity_ter=='nan'){
		echo "Error";
	}else{
		mysqli_query($con, "INSERT INTO dati_sensori(temperature, humidity, humidity_ter, luminosity) VALUES ('$temperature', '$humidity', '$humidity_ter', '$luminosity')");
    	echo "100";
	}
}else if(isset($type)&&isset($value)){
	mysqli_query($con, "UPDATE setting SET value=".$value." WHERE type='".$type."'");
}else{
	echo "Error2";
}

