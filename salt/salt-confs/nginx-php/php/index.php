<?php
$conn=null;
    function query($sql){
        //empty 判断一个变量的值是否为空
        global $conn;
        $conn=mysqli_connect('localhost','root','');//连接数据库服务器
        mysqli_select_db($conn,'information_schema');//选中要操作的数据库
        mysqli_query($conn,'set names utf8');//执行一个SQL语句
        $result=mysqli_query($conn,$sql);//设置指定编码格式
        return $result;   
    }
     
    /*
    *执行SQL查询数据
    *@param[参数] $sql  执行查询的SQL语句
    *@param[参数] $isnum 是否返回数字键的数组  如果为true返回数字键数组//否则返回false
    *@return[返回] array 查询的结果数组 如果返回false查询失败
    */
    function select($sql,$isnum=false){
        $result=query($sql);
        if($result){
            $resultArray=array();
            if($isnum){
                while($arr=mysqli_fetch_row($result)){
                    array_push($resultArray,$arr);
                }
            }else{
                while($arr=mysqli_fetch_assoc($result)){
                    array_push($resultArray,$arr);
                }
            }
            return $resultArray;           
        }else{
            return false;
        }
    }
     
    //验证
    $arr=select('select * from ENGINES');
    print_r($arr);
?>
