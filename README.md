Windows Disk Cleanup
====================

Overview
--------

Windows Disk Cleanup is a script designed to clean up disk space on a Windows machine by performing various cleanup tasks. The script automates the process of removing temporary files, emptying the recycle bin, clearing SCCM cache, disabling hibernation, running the Windows Disk Cleanup tool, enabling NTFS compression, restricting Outlook OST file size, and deleting iTunes backups and old software updates.

Features
--------

*   **Remove Temporary Files:** Cleans up temporary files from various directories.
    
*   **Empty Recycle Bin:** Empties the recycle bin to free up space.
    
*   **Clear SCCM Cache:** Clears the SCCM cache by removing elements older than 15 days.
    
*   **Disable Hibernation:** Disables hibernation to save disk space.
    
*   **Run Disk Cleanup Tool:** Executes the Windows Disk Cleanup tool.
    
*   **Enable NTFS Compression:** Enables NTFS compression on specific directories.
    
*   **Restrict Outlook OST File Size:** Limits the maximum size of Outlook OST files.
    
*   **Delete iTunes Backups and Software Updates:** Removes iTunes backups and iOS software updates.
    

Author
------

*   **Florian Bidabe**
    

Usage
-----

1.  **Initialize the Script:**
    
    *   The script initializes by setting various variables and paths required for the cleanup process.
        
2.  **Remove Temporary Files:**
    
    *   The script removes temporary files from user and system directories.
        
3.  **Empty Recycle Bin:**
    
    *   The script empties the recycle bin.
        
4.  **Clear SCCM Cache:**
    
    *   The script clears the SCCM cache by removing elements older than 15 days.
        
5.  **Disable Hibernation:**
    
    *   The script disables hibernation to save disk space.
        
6.  **Run Disk Cleanup Tool:**
    
    *   The script runs the Windows Disk Cleanup tool.
        
7.  **Enable NTFS Compression:**
    
    *   The script enables NTFS compression on specific directories.
        
8.  **Restrict Outlook OST File Size:**
    
    *   The script restricts the maximum size of Outlook OST files.
        
9.  **Delete iTunes Backups and Software Updates:**
    
    *   The script deletes iTunes backups and iOS software updates.
        

Notes
-----

*   The script requires elevated privileges to perform certain tasks.
    
*   It temporarily adds the current user to the local Administrators group to execute commands with elevated privileges.
    
*   The script handles incorrect credentials by prompting the user to re-enter the correct credentials.
    

Disclaimer
----------

*   The script is provided as-is without any warranty.
    
*   Use the script at your own risk.
    
*   Ensure you have backups of important data before running the script.
    

Contact
-------

For any questions or issues, please contact Florian Bidabe.