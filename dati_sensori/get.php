<?php
$conn = mysqli_connect('localhost', 'progettomiotto', '', 'my_progettomiotto');
$type = $_GET['type'];

if(isset($type)){
	if($type=="app"){
	$json = array();
    $result = mysqli_query($conn, "SELECT * FROM dati_sensori");
    $result2 = mysqli_query($conn, "SELECT * FROM setting");
    if(mysqli_num_rows($result)!==0 and mysqli_num_rows($result2)!==0){
      while ($row = mysqli_fetch_array($result)){
        $time = $row['time'];
        $humidity = $row['humidity'];
        $humidity_ter = $row['humidity_ter'];
        $temperature = $row['temperature'];
        $luminosity = $row['luminosity'];
      }
      $json["sensore"]["time"] = $time;
      $json["sensore"]["humidity"] = $humidity;
      $json["sensore"]["temperature"] = $temperature;
      $json["sensore"]["humidity_ter"] = $humidity_ter;
      $json["sensore"]["luminosity"] = $luminosity;
   	  while ($row2 = mysqli_fetch_array($result2)) {
		$type = $row2['type'];
        $value = $row2['value'];
		$json["setting"][$type] = $value;
  	  }
      echo(json_encode($json));
    }else{
      echo("non va");
      }
	}else if($type=="storico"){
      $json = array();
      $i=0;
      $result = mysqli_query($conn, "SELECT * FROM dati_sensori ORDER BY ID DESC LIMIT 20");
      if(mysqli_num_rows($result)!==0){
        while ($row = mysqli_fetch_array($result)){
          $time = $row['time'];
          $humidity = $row['humidity'];
          $humidity_ter = $row['humidity_ter'];
          $temperature = $row['temperature'];
          $luminosity = $row['luminosity'];
          $json["sensore"][$i]["time"] = $time;
          $json["sensore"][$i]["humidity"] = $humidity;
          $json["sensore"][$i]["temperature"] = $temperature;
          $json["sensore"][$i]["humidity_ter"] = $humidity_ter;
          $json["sensore"][$i]["luminosity"] = $luminosity;
          $i++;
        }
        echo(json_encode($json));
        }
    }else if($type=="sensore"){
    $result = mysqli_query($conn, "SELECT * FROM dati_sensori");
    if(mysqli_num_rows($result)!==0){
      while ($row = mysqli_fetch_array($result)){
        $time = $row['time'];
        $humidity = $row['humidity'];
        $humidity_ter = $row['humidity_ter'];
        $temperature = $row['temperature'];
      }
      $json = [
        "time" => $time,
        "humidity" => $humidity,
        "temperature" => $temperature,
        "humidity_ter" => $humidity_ter,
      ];
      echo(json_encode($json));
    }else{
      echo("500");
    }
	}else{
	$result = mysqli_query($conn, "SELECT * FROM setting WHERE type='$type'");
    	if(mysqli_num_rows($result)!=0){
   		while ($row = mysqli_fetch_array($result)) {
			$value = $row['value'];
            $value2 = $row['value2'];
  		}
      echo($value);
    }
  }
}else{
	echo("300");
}