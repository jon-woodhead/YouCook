<?php

echo "<xml><OK>YES</OK>";
    
     $connect = mysql_connect("localhost","j02tour_jon","WOZVM875") or 
    die ("failed to connect to database");
   
    mysql_select_db("j02tour_YouCook");

//$link = mysqli_connect("localhost","j02tour_jon","WOZVM875","j02tour_YouCook") or die("Error " . mysqli_error($link));
    
    $ids = trim(strip_tags(htmlentities($_REQUEST['ids'])));
     
    
     if(!isset($ids)) { 
          $ids = 'ThereIsNoKeywordSetSoreturnNothing';
     }
     
    
$idArray = explode(',', $ids);
$ids = array_unique($ids);
 //print_r($keywordArray);
   
   
    $query='SELECT *   FROM Recipes WHERE ';

    $lastElement = end($idArray);
    foreach ($idArray as &$value) {
       $query .= 'id LIKE "'.$value.'" ';
        if($value != $lastElement) {
             $query .= 'OR ';
        }
    }
    
    //echo $query;
  
    
    $results = mysql_query($query) or die (mysql_error());
    
    while ($rows = mysql_fetch_assoc($results))
    {
       
        echo "<recipe>";
        echo "<id>".$rows["id"]."</id>";
        echo "<title>".$rows["title"]."</title>";
        echo "<outline>".$rows["outline"]."</outline>";
        echo "<ingredients>".$rows["ingredients"]."</ingredients>";
		$ingredients = explode('^', $rows["ingredients"]);
		 foreach ($ingredients as &$value) {
			echo "<ingredient>".$value."</ingredient>";
			}
 echo "<instructions>".$rows["instructions"]."</instructions>";
        echo "<photo>".$rows["photoURL"]."</photo>";
         echo "<chef>".$rows["chef"]."</chef>";
        echo "<chefCode>".$rows["chefCode"]."</chefCode>";
       echo "</recipe>";
     
       }

     mysql_free_result($results);  
   
    echo "</xml>";  
       
?>