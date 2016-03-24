package com.cesnet.pki;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author jana
 */
public class Sosator {
        
    private final String pathToDirectory = "/opt/";
    private final String pathActualDate = "ejbca.json";    
    private final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
    
    /** 
     * @return content of actual saved data
     * @throws IOException - if an I/O error occurs reading from the stream
     */
    public String loadActualData() throws IOException  {
        return new String(Files.readAllBytes(Paths.get(pathToDirectory + pathActualDate)));
    }

    /**
     * finds existing file with nearest date
     * 
     * @param date - desirable date. Date must be in format yyyy-MM-dd.
     * @return content of existing saved data
     * @throws ParseException - if the beginning of the specified string cannot be parsed.
     */
    public String loadNearest(String date) throws ParseException  {
        
        Date requestedDate;
        
        requestedDate = format.parse(date);
                        
        String nearestNameFile = "";
               
        // list all files in path        
        File folder = new File(pathToDirectory);
        File[] listOfFiles = folder.listFiles();

        Long minDiff = Long.MAX_VALUE;
        
        for (File listOfFile : listOfFiles) {
            if (listOfFile.isFile()) {
                try {            
                    Date fileNameDate = format.parse(listOfFile.getName());
                    
                    Long diff = Math.abs(fileNameDate.getTime()-requestedDate.getTime());
                    
                    if (diff < minDiff) {
                        minDiff = diff;
                        nearestNameFile = listOfFile.getName();
                    }
                    
                } catch (ParseException ex) {
                    // continue (not our file)
                }  
            }            
        }
    
        return nearestNameFile;
    }
}