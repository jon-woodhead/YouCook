<?php
    
    $connect = mysql_connect("localhost","j02tour_jon","WOZVM875") or
    die ("Fail");
    
    mysql_select_db("j02tour_YouCook");
    
    $title = trim(strip_tags(htmlentities($_REQUEST['title'])));
	$title = str_replace ("'","''",$title);
$outline = trim(strip_tags(htmlentities($_REQUEST['outline'])));
		$outline = str_replace ("'","''",$outline);
     $instructions = trim(strip_tags(htmlentities($_REQUEST['instructions'])));
		$instructions = str_replace ("'","''",$instructions);
     $chef = trim(strip_tags(htmlentities($_REQUEST['chef'])));
		$chef = str_replace ("'","''",$chef);
     $chefCode = trim(strip_tags(htmlentities($_REQUEST['chefCode'])));
     $ingredients = trim(strip_tags(htmlentities($_REQUEST['ingredients'])));
		$ingredients = str_replace ("'","''",$ingredients);
$photoURL = trim(strip_tags(htmlentities($_REQUEST['photoURL'])));
        //echo "1";
    if(!isset($title) || !isset($outline) ||!isset($instructions) || !isset($chef)|| !isset($chefCode) || !isset($ingredients)) {
       die ("Invalid inputs");
    }
    
        
   //echo $title;
//echo "/n";

        
  $query="INSERT INTO Recipes (title, outline,instructions,chef,chefCode,ingredients,photoURL) VALUES ('". $title."','". $outline."','". $instructions."','".$chef."','".$chefCode."','".$ingredients."','".$photoURL."')";

         	//$query="INSERT INTO fake (NNN) VALUES ('QQQ')";

   //echo $query ;
    //$query="INSERT INTO waypoints (title, description,latitude,longitude,views,like,tour_id) VALUES ('A','B','0','0','1','3','1')";
    //$query="INSERT INTO waypoints (title, description,latitude,longitude,likes) VALUES ('A','B','0','0','1')";

   
   //echo $query;
    
    mysql_query($query) or die (mysql_error()."<xml><OK>NO</OK></xml>");
 $id = mysql_insert_id();
   
    
        echo "<xml><OK>YES</OK><id>";
   echo   $id;
  echo "</id></xml>";
    mysql_close($connect); 
   
        ?>