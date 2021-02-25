import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class answer {

	 static ArrayList<String> Input, Output;
	 
	 static ArrayList<String> Solve(ArrayList<String> input) {
	        ArrayList<String> bs = new ArrayList<String>();
	        int j;
			String t;
	       for(j=0;j<input.size();++j)
	       {
	    	   t=Input.get(j);
	    	   bs.add(t);
	       }
	        return bs;
	    }
	 
	public static void main(String[] args) throws FileNotFoundException
	{
		// TODO Auto-generated method stub
		String[] fileNames = {"a", "b", "c", "d", "e","f"};
        for (int i = 0; i < fileNames.length; i++)
        {
            getInputFromFile(fileNames[i]);
            Output = Solve(Input);
            writeIntoFile(fileNames[i]);
        }
	}
	
	 static void getInputFromFile(String fileName) throws FileNotFoundException {
	        try {
	            Input = new ArrayList<String>();
	            BufferedReader fr = new BufferedReader(new FileReader("input\\" + fileName + ".txt"));
	            String line, firstLine;
	            firstLine = fr.readLine();
	            String[] vars;
	            vars = firstLine.split(" ");
	            int time=Integer.valueOf(vars[0]); // For similation time
	            int intsec=Integer.valueOf(vars[1]); // For no of intersection
	            int st=Integer.valueOf(vars[2]); // For no of streets
	            int cars=Integer.valueOf(vars[3]); // For no of cars
	            int score=Integer.valueOf(vars[4]); // For total score
	            while ((line = fr.readLine()) != null)
	            {
	                String letters[] = line.split(" ");
	                for (int i = 0; i < letters.length; i++) 
	                {
	                    Input.add(letters[i]);
	                }
	            }
	            fr.close();
	        } catch (IOException ex) {
	            Logger.getLogger(answer.class.getName()).log(Level.SEVERE, null, ex);
	        }
	    }
	 
	 static void writeIntoFile(String fileName) 
	 {
	        try {
	            PrintWriter outputFile = new PrintWriter("output\\" + fileName + ".txt", "UTF-8");
	            for (int i = 0; i < Output.size(); i++) {
	                outputFile.println(Output.get(i) + " ");
	            }
	            outputFile.close();
	        } catch (Exception e) {
	            System.err.println("" + e);
	        }
	    }
	 

}
