
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ani
 */

import java.io.*; 
import java.text.*; 
import java.util.*; 
import java.net.*;
import java.util.concurrent.*;
import java.util.regex.*;
import javax.swing.*;

class Storage {
    
    int cookies ; 
    int snacks; 
    int currentTotalTime ; 
    protected BlockingQueue<Integer> queue;
    int counter ; 
    int orderId ;
    int deficientSupply ; 
    String MonthlyOrders  ;
    String allOrders ; 
    HashMap<String, String> map ; 
    Storage( int coval , int sval , BlockingQueue<Integer> queue ){
        this.cookies = coval ;
        this.snacks = sval ;
        this.currentTotalTime  = 0 ;
        this.queue = queue;
        this.counter = 0 ; 
        this.orderId = 0 ;
        this.deficientSupply = 0 ; 
        this.MonthlyOrders = "" ; 
        this.allOrders = "" ; 
        map = new HashMap<>() ; 
    }
    String TimeEvaluator(int t1 , int c1){
        return "" ; 
    }
    String Order( String input  ){
       String[] arr = input.split("[;]");
        
        int t1 = Integer.valueOf(arr[0]);   // Quantity of tea ordered
        int c1 = Integer.valueOf(arr[1]);   //Quantity of Coffee Ordered
        int c2 = Integer.valueOf(arr[2]);   // Quantity of Cookies Ordered
        int s1 = Integer.valueOf(arr[3]);   // Quantity of Snacks ordered 
        if (this.cookies <= 10 || this.snacks <= 10) {
            supplyDeflect();
        }
        if(c2 <= this.cookies){
           this.cookies = this.cookies - c2 ; 
        }else{
        	String str = "NO:"+Integer.toString(this.cookies)+":"+Integer.toString(this.snacks) ; 
            return str ; 
        }
        if(s1 <= this.snacks ){
            this.snacks = this.snacks - s1 ; 
        }else{
            String str = "NO:"+Integer.toString(this.cookies)+":"+Integer.toString(this.snacks) ; 
            return str ; 
        }
        try{
        	System.out.println("Putting order in queue");
        	this.orderId++; 
        	int ct = this.counter ; 
        	ct = Math.max(ct , this.currentTotalTime); 
        	// int k =  queue.peek() ; 
        	int ft = t1 + c1 +ct ;
        	this.counter = ft ;
        	// Adding date to current order

        	DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

			// Get the date today using Calendar object.
			Date today = Calendar.getInstance().getTime();        
			// Using DateFormat format method we can create a string 
			// representation of a date with the defined format.
			String reportDate = df.format(today);

			// Print what date is today!
			// System.out.println("Report Date: " + reportDate);


        	System.out.println("You will recive order in "+ (ft - this.currentTotalTime +2) + " SECONDS");
        	String OrderDetails = "Order Details : Date:" + reportDate+ " Name : "+ arr[4]+ "   OrderId : "+ arr[5] + "\n Tea :"+ arr[0]+" \n Coofee : "+arr[1] + " \n Cookies : "+arr[2]+" \n Snacks : "+arr[3]+"\n" ; 
            
			if(map.containsKey(reportDate)){
				String temp = map.get(reportDate);
				temp = temp + OrderDetails ; 
				map.put(reportDate , temp) ; 
			}else{
				map.put(reportDate , OrderDetails) ; 
			}

            this.MonthlyOrders = this.MonthlyOrders +  OrderDetails; 
            this.allOrders = this.allOrders +  this.MonthlyOrders ; 
            queue.put(ft);
            String str = "YES:"+Integer.toString(ft - this.currentTotalTime +2)+":"+Integer.toString(this.orderId) ; 
           	return str ; 
        }catch(Exception e){
            e.printStackTrace();
        }
        
        return "NO" ; 
    }
    void supplyDeflect(){
        
        this.deficientSupply = 1 ;
    }
}


public class Server {
    public static void main(String[] args) throws Exception {
       ServerSocket ss = new ServerSocket(5050) ; // creating a socket at port 5050 
       BlockingQueue queue  = new ArrayBlockingQueue<Integer>(1024)  ;
       Storage quantity = new Storage(100 , 100 ,queue ) ;
       GUI2 g = new GUI2() ;
       Thread t2 = new Customer(queue , quantity , g) ;
		g.setVisible(true);
       t2.start(); 
       while(true){                                    // loop chich will keep on accepting new requests
            Socket s = null; 
            try{
                s = ss.accept() ;                  // will run if new connection wants to make socket
                DataInputStream dis = new DataInputStream(s.getInputStream()); 
                DataOutputStream dos = new DataOutputStream(s.getOutputStream());
                Thread t = new customerHandler(s , dis , dos , quantity ) ;
                t.start() ; 
            }catch(Exception e){
                ss.close();
                e.printStackTrace(); 
            }
        }
    }

    
}


class customerHandler extends Thread {
    final Socket s ; 
    final DataInputStream din ;
    final DataOutputStream dout ; 
    Storage quantity ; 
    
    customerHandler(Socket s ,DataInputStream din ,DataOutputStream dout, Storage quantity ){
        this.s = s ; 
        this.din = din ; 
        this.dout = dout ; 
        this.quantity = quantity ; 
         
    }
    
    @Override
    public void run(){
        String input ; 
        String output; 
        while(true){
            
            try{
                input = din.readUTF();    
               // System.out.println(input); 
            }catch(Exception e){
                System.out.println("Input cant be read ");
                e.printStackTrace();
                return ; 
            }
//
            if(input.equals("EXIT")){      // input EXIT is send when client want to finish connection
                try{
                    System.out.println("Closing this connection."); 
                    this.s.close(); 
                    System.out.println("Connection closed"); 
                }catch(Exception e){
                    System.out.println("Error cloding the socket ");
                    e.printStackTrace();
                }
            }else{
            		String str ;
            		synchronized(quantity){
                    str = quantity.Order(input);
            		}
            		try{
            		dout.writeUTF(str) ;
            		}catch(Exception e){
            			e.printStackTrace() ; 
            		}
            		return ;
            }
            
        }
    }
}

class Customer extends Thread{
protected BlockingQueue<Integer> queue ;
Storage quantity ; 
GUI2 g;
    Customer(BlockingQueue<Integer> queue ,Storage quantity , GUI2 g  ){
        this.queue = queue; 
        this.quantity = quantity ;
        this.g = g ;   
    }
    
    @Override
    public void run(){
        try{
            while(true){
            	int k = quantity.currentTotalTime ; 
            	
            	// System.out.println(quantity.currentTotalTime); 
            	quantity.currentTotalTime++; 
            	if(k%50 == 0){
            		System.out.println("periodic sales update is ready ") ; 
            		g.UpdateValue(quantity.deficientSupply , quantity.MonthlyOrders); 	
            		quantity.MonthlyOrders  = "" ; 
            	}
            	 Thread.sleep(1000);
                if(queue.size() > 0 && k == queue.peek() ){
                	// quantity.counter = quantity.counter + k ; 
                	queue.poll(2000 ,TimeUnit.SECONDS);

                	System.out.println("Order has left the shop will reach to you in 2 minutes"); 
                }
                 
            }
        }catch(Exception e){
            e.printStackTrace(); 
        }
    }
}
class GUI2 extends javax.swing.JFrame {
	 GUI2() {
        initComponents();

    }
    @SuppressWarnings("unchecked")
    private void initComponents() {

        jLabel12 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();

        jLabel12.setText("Weekly Report ");

        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jScrollPane2.setViewportView(jTextArea1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        // layout.getContentPane().setLayout(this);
        // this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(198, 198, 198)
                        .addComponent(jLabel12))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(73, 73, 73)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 391, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(41, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel12)
                .addGap(58, 58, 58)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 218, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(97, Short.MAX_VALUE))
        );
        // jTextArea1.setText("Anirudh ") ;
    }// </editor-fold>
    void UpdateValue( int flag , String str){
        if(flag == 1){
            jTextArea1.setText("") ;
            System.out.println(" refil the supply \n");
            jTextArea1.setText("Supply of cookies or snacks has reached below 10\n"+str) ; 
        }else{
            jTextArea1.setText("") ; 
            jTextArea1.setText(str) ;
        }
    }
    private javax.swing.JLabel jLabel12;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTextArea jTextArea1;
    
    
}