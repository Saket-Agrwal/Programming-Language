import java.util.Random;
import java.util.LinkedList; 
import java.util.Queue; 
import java.io.*; 
import java.util.*; 
 
class Sock
{
    int color;
    int permanent_lock;
    int sync_lock;

    public Sock(int color){
        this.color = color; 
        this.permanent_lock = 0; 
        this.sync_lock = 0;
    }
}

class MatchingMachine
{
    Queue<Integer> red = new LinkedList<>(); 
    Queue<Integer> green = new LinkedList<>(); 
    Queue<Integer> blue = new LinkedList<>(); 
    Queue<Integer> yellow = new LinkedList<>();

    public void match(int color,int number) 
    { 
        if(color == 0)
        {
            red.add(number);
            if( red.size() >= 2 )
            {
                int first = red.remove(); 
                int second = red.remove();
                System.out.println("Matching machine matched socks of red color from arms: "+ first +" and "+ second);
            }
        }
        else if(color == 1)
        {
            green.add(number);
            if( green.size() >= 2 )
            {
                int first = green.remove(); 
                int second = green.remove();
                System.out.println("Matching machine matched socks of green color from arms: "+ first +" and "+ second);
            }
        }
        else if(color == 2)
        {
            blue.add(number);
            if( blue.size() >= 2 )
            {
                int first = blue.remove(); 
                int second = blue.remove();
                System.out.println("Matching machine matched socks of blue color from arms: "+ first +" and "+ second);
            }
        }
        else
        {
            yellow.add(number);
            if( yellow.size() >= 2 )
            {
                int first = yellow.remove(); 
                int second = yellow.remove();
                System.out.println("Matching machine matched socks of yellow color from arms: "+ first +" and "+ second);
            }
        }
    } 
}

class Arm extends Thread
{
    int number;
    MatchingMachine m;
    Sock [] arr;
    int size;

    public Arm(int number , MatchingMachine m, Sock [] arr,int size){
        this.number = number ; 
        this.m = m ; 
        this.arr = arr;
        this.size = size;
    }

    public void run()
    {
        while(true)
        {
            int flag = 0;
            for(int i=0;i<this.size;i++)
            {
                while( arr[i].sync_lock == 1 )
                    continue;
                arr[i].sync_lock = 1;
                if(arr[i].permanent_lock != 1)
                {
                    flag = 1;
                    arr[i].permanent_lock = 1;
                    synchronized(m) 
                    { 
                        m.match( arr[i].color,this.number ); 
                    } 
                }
                arr[i].sync_lock = 0;
            }
            if(flag == 0)
                break;
        }
    }
}

// Driver class
class DriverClass
{
    public static void main(String args[]) 
    {
        System.out.println("Enter number of socks:");
        int n = Integer.parseInt(System.console().readLine());
        Sock arr[];
        arr = new Sock[n];
        int i = 0;
        while(i<n)
        {
            Random rand = new Random();
            int  color = (rand.nextInt(50) + 1)%4;
            arr[i] = new Sock(color);
            i++;
        }
        MatchingMachine matchingMachine = new MatchingMachine(); 
        System.out.println("Enter number of robotic arms:");
        int m = Integer.parseInt(System.console().readLine());
        i = 0;
        while(i<m)
        {
            Arm s =  new Arm( i,matchingMachine,arr,n ); 
            s.start(); 
            i++;
        }

    }
}