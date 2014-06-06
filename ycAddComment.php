<?php
    
    $connect = mysql_connect("localhost","j02tour_jon","WOZVM875") or
    die ("Fail");
    
    mysql_select_db("j02tour_YouCook");
    
    $recipe = trim(strip_tags(htmlentities($_REQUEST['recipe'])));

	$user = trim(strip_tags(htmlentities($_REQUEST['user'])));
		$user = str_replace ("'","''",$user);
     $date = trim(strip_tags(htmlentities($_REQUEST['date'])));
	
     $body = trim(strip_tags(htmlentities($_REQUEST['body'])));
		$body = str_replace ("'","''",$body);
		
		 if(!isset($recipe) || !isset($user) ||!isset($date) || !isset($body)){
       die( "Invalid inputs");
    }
    
        
   //echo $recipe;

//echo "/n";

      
  $query="INSERT INTO comments (recipeId, userName,date,body) VALUES ('". $recipe."','". $user."','". $date."','".$body."')";

   //echo $query;      	
   
    mysql_query($query) or die ("<xml><OK>NO</OK></xml>");
 $id = mysql_insert_id();
   
    
        echo "<xml><OK>YES</OK><id>";
   echo   $id;
  echo "</id></xml>";
    mysql_close($connect); 
   
        ?>