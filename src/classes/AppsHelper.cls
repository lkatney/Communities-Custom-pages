/**********************************************************************
 Name:  AppsHelper
 Copyright © 2015
 ======================================================
======================================================
Purpose:                                                            
-------  
Helper methods
======================================================
======================================================
***********************************************************************/
public without sharing class AppsHelper {

    @TestVisible private Static final String USERNAME_BLANK_MSG = 'Username is blank';
    @TestVisible private Static final String USERNAME_FORMAT_MSG = 'Username format is not correct';
    @TestVisible private Static final String USERNAME_NOT_FOUND_MSG = 'Username not found in system';
    @TestVisible private Static final String PW_CONFIRM_F = 'Password fields cannot be blank';
    @TestVisible private Static final String PW_CREATE = 'Password fields cannot be blank';
    @TestVisible private Static final String PW_DONT_MATCH = Label.site.passwords_dont_match;
    @TestVisible private Static final String PW_ENTER_OLD = 'Enter old password';
    
    private Static final String DEFAULT_PORTAL_ACCOUNT = 'Portal Account';
    private Static final String DEFAULT_PORTAL_PROFILE = 'Customer Community User';


    /***************************************************************************

    Purpose     : Gets default account for community

    Returns     : Id

    ***************************************************************************/
    public static Account getDefaultPortalAccount(){
       return [SELECT Id FROM Account WHERE name =: DEFAULT_PORTAL_ACCOUNT];
    }

    /***************************************************************************

    Purpose     : Gets default profile  for community

    Returns     : Id

    ***************************************************************************/
    public static Profile getDefaultProfile(){
       return [SELECT Id FROM Profile WHERE Name =: DEFAULT_PORTAL_PROFILE];
    }

    

    /********************************************************************************************
        Purpose:  Method to check username exists in system
    ********************************************************************************************/
    public static String isUsernameExist(String username){
        // List<User> userLst = [SELECT Id FROM User WHERE Username =: username];
        // if(!userLst.isEmpty()){
        //     return null;
        // }else{
        //     return USERNAME_NOT_FOUND_MSG;
        // }
        
        return null;
    }
    /********************************************************************************************
        Purpose:  Method to check username or email address
    ********************************************************************************************/
    public static String checkUsername(String username){
         if(String.isBlank(username)){
            return USERNAME_BLANK_MSG;
        }else{
            if(checkValidUsernameFormat(username)){
                return null;
            }else{
                return USERNAME_FORMAT_MSG;
            }
        }

    }

    /********************************************************************************************
        Purpose:  Method to check valid email address/username
    ********************************************************************************************/
    public static Boolean checkValidUsernameFormat(String emailAddress){
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(emailRegex);

        Matcher MyMatcher = MyPattern.matcher(emailAddress);

        if(MyMatcher.matches()){
            return true;
        }else{
            return false;
        }
    }

    /********************************************************************************************
        Purpose:  Method to check valid passwords and check messages approriately
    ********************************************************************************************/
    public static String checkPasswords(String oldpassword, String newPassword, String verifyNewPassword){
        if (String.isEmpty(oldpassword) && !Site.isPasswordExpired()) {          
            return PW_ENTER_OLD;
        }

        if (String.isEmpty(newPassword)) {
            return PW_CREATE;    
        }

        if (String.isEmpty(verifyNewPassword)) {
            return PW_CONFIRM_F;        
        }

        if (verifyNewPassword != newPassword) {
            return PW_DONT_MATCH;
        }

        return null;
    }

}