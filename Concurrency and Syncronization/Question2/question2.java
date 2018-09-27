import java.util.*;
import java.util.concurrent.*;
import java.io.*;

class Student
{
    String rollNumber;
    String name;
    String mailId;
    int marks;
    String teacher;
    int flag;
    Semaphore sem;

    public Student(String rollNumber , String name, String mailId , int marks, String teacher){
        this.rollNumber = rollNumber ; 
        this.name = name ; 
        this.mailId = mailId ; 
        this.marks = marks ;
        this.teacher = teacher;
        this.flag = 0;
        if(this.teacher.equals("CC"))
            this.flag = 1;
        this.sem = new Semaphore(1); 
        this.sem.release();
    }
}

class Input extends Thread
{
    String rollNumber;
    String teacher;
    int x;
    int marks;
    int sync_flag;
    Student records[];

    Input(String rollNumber , String teacher, int x , int marks,Student[] records){
        this.rollNumber = rollNumber ; 
        this.teacher = teacher ; 
        this.x = x ; 
        this.marks = marks ;
        this.records = records;
    }

    public void run()
    {
        int i = 0;
        for(int j=0;j<5;j++)
        {
            if( this.rollNumber == records[j].rollNumber )
            {
                i = j;
                break;
            }
        }

        if(this.sync_flag == 0)
        {
            if(this.teacher.equals("CC"))
            {
                if( x==1 )
                    records[i].marks += this.marks;
                else
                    records[i].marks -= this.marks;
                records[i].teacher = "CC";
                records[i].flag = 1;
            }
            else
            {
                if( records[i].flag != 1 )
                {
                    if( x==1 )
                        records[i].marks += this.marks;
                    else
                        records[i].marks -= this.marks;
                    if(this.teacher.equals("TA1"))
                        records[i].teacher = "TA1";
                    else
                        records[i].teacher = "TA2";
                }
            }
        }
        else
        {
            if( records[i].flag != 1 )
            {
                try
                {
                    records[i].sem.acquire();
                    if(this.teacher.equals("CC"))
                    {
                        if( x==1 )
                            records[i].marks += this.marks;
                        else
                            records[i].marks -= this.marks;
                        records[i].teacher = "CC";
                        records[i].flag = 1;
                    }
                    else
                    {
                        if( records[i].flag != 1 )
                        {
                            if( x==1 )
                                records[i].marks += this.marks;
                            else
                                records[i].marks -= this.marks;
                            if(this.teacher.equals("TA1"))
                                records[i].teacher = "TA1";
                            else
                                records[i].teacher = "TA2";
                        }
                    }
                    records[i].sem.release();
                }
                catch(InterruptedException e)
                {

                }
            }
        }
    }

}

class Sortbyroll implements Comparator<Student> 
{ 
    public int compare(Student a, Student b) 
    { 
        String roll1 = a.rollNumber;
        String roll2 = b.rollNumber;
        return roll1.compareTo(roll2);
    } 
}

class Sortbyname implements Comparator<Student> 
{ 
    public int compare(Student a, Student b) 
    { 
        String name1 = a.name;
        String name2 = b.name;
        return name1.compareTo(name2);
    } 
}

class DriverClass
{
    public static void main(String[] args)
    {
        Student records[];
        records = new Student[5];
        int i = 0;
        try
        {
            File f = new File("Stud_Info.txt");
            Scanner scanner = new Scanner(f);
            while(scanner.hasNextLine())
            {
                String line = scanner.nextLine();
                String[] details = line.split("\t");
                String rollNumber = details[0];
                String name = details[1];
                String mail = details[2];
                int mark = Integer.parseInt(details[3]);
                String teacher = details[4];

                Student temp = new Student( rollNumber, name, mail, mark, teacher);
                records[i]=temp;
                i++;
            }
        }
        catch( FileNotFoundException e)
        {
            System.out.println("AA gya mc");
        }

        System.out.println("Enter number of inputs:");
        int n = Integer.parseInt(System.console().readLine());
        Input arr[];
        arr = new Input[n];
        i = 0;
        while(i<n)
        {
            System.out.println("Enter Teacher’s Name:");
            String teacher = System.console().readLine();
            System.out.println("Enter Student Roll number:");
            String rollNumber = System.console().readLine();
            System.out.println("Update Mark:");
            System.out.println("1.Increase:");
            System.out.println("2.Decrease:");
            int x  = Integer.parseInt(System.console().readLine());
            int marks;
            if(x==1)
            {
                System.out.println("Mark to add:");
                marks  = Integer.parseInt(System.console().readLine());
            }
            else
            {
                System.out.println("Mark to deduct:");
                marks  = Integer.parseInt(System.console().readLine());
            }
            arr[i] = new Input(rollNumber,teacher,x,marks,records);
            i++;
        }
        while(true)
        {
            System.out.println("Choose one:");
            System.out.println("1.Without Synchronization");
            System.out.println("2.With Synchronization");
            int z = Integer.parseInt(System.console().readLine());
            if(z==1)
            {
                i = 0;
                while(i<n)
                {
                    arr[i].sync_flag = 0;
                    arr[i].start();
                    i++;
                }
            }
            else
            {
                i = 0;
                while(i<n)
                {
                    arr[i].sync_flag = 1;
                    arr[i].start();
                    i++;
                }
            }


            try
            {
                PrintWriter f1 = new PrintWriter("roll_sort.txt");
                Arrays.sort(records,new Sortbyroll());
                for(i = 0;i<5;i++)
                    f1.println( records[i].rollNumber + "\t" + records[i].name + "\t" + records[i].mailId + "\t" + records[i].marks + "\t" + records[i].teacher);    
                f1.close();
            }
            catch( FileNotFoundException e)
            {
            }

            try
            {
                PrintWriter f2 = new PrintWriter("name_sort.txt");
                Arrays.sort(records,new Sortbyname());
                for(i = 0;i<5;i++)
                    f2.println( records[i].rollNumber + "\t" + records[i].name + "\t" + records[i].mailId + "\t" + records[i].marks + "\t" + records[i].teacher); 
                f2.close();
            }
            catch( FileNotFoundException e)
            {
            }

            System.out.println("Check the output files.");
            System.out.println("Do you want to continue? yes/no.");
            String ans = System.console().readLine();
            if(ans.equals("no"))
                break;
        }
        System.out.println("Done.");
    }
}