/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


import java.io.*; 
import java.net.*; 
import java.util.Scanner; 

/**
 *
 * @author ani
 */
class Client {
    String Setup(int tea , int coffee ,int cookies , int snacks , String name, String roomno){
        try{
            Scanner scn = new Scanner(System.in) ; 
            InetAddress ip = InetAddress.getByName("localhost"); 
            Socket s = new Socket(ip, 5050);
            DataInputStream dis = new DataInputStream(s.getInputStream()); 
            DataOutputStream dos = new DataOutputStream(s.getOutputStream());
                String output ; 
//                output = scn.nextLine() ; 
                dos.writeUTF(Integer.toString(tea)+";"+Integer.toString(coffee)+";"+Integer.toString(cookies)+";"+ Integer.toString(snacks)+";"+name+";"+"roomno") ;
                String recieved = "" ; 
                while(true){
                    recieved = dis.readUTF();
                    if(!recieved.equals("")){
                        break;
                    }
                }
                System.out.println(recieved) ;
                s.close() ; 
                scn.close() ; 
                dis.close() ; 
                dos.close() ; 
                return recieved; 
        }catch(Exception e){
             e.printStackTrace(); 
        }
        return "" ; 
    }
}
