/*******************************************************************************
 Name:  CommunitiesLogicController
 Copyright © 2015 XXX
================================================================================
================================================================================
Purpose:                                                            

Controller to handle all custom logic for community landing/login/change password/forgot password
================================================================================
================================================================================
*******************************************************************************/
public with sharing class CommunitiesLogicController {
    
    //variables used across login, forgotpassword , changeassword pages
    public String username {get; set;}
    public String password {get; set;}
    public Boolean success {get;set;}
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;} 
    
    //variables used for registration page
    public User newUser{get;set;}
    public String optPassword{get;set;}
    public String optConfirmPassword{get;set;}

    public CommunitiesLogicController(){
        newUser = new User();
    }

    /********************************************************************************************
        Purpose:  method to create a  community user on registration page
        Returns: Pagereference to login page
    ********************************************************************************************/
    public PageReference registerUser(){

        //check if both password matches or not
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    

        Id accountId = AppsHelper.getDefaultPortalAccount().Id;
        Id profileId = APPsHelper.getDefaultProfile().Id;
    
        System.debug(newUser);
        
        String message = AppsHelper.checkUsername(newUser.username);
        if(String.isNotBlank(message)){
            throwError(message);
            return null;
        }

        newUser.ProfileId = profileId;
        newUser.CommunityNickname = newUser.Firstname.substring(0,1) + newUser.Firstname.substring(0,3) + Math.random() * 1000;

        Id userId = Site.createPortalUser(newUser, accountId, optPassword);
        if(userId != null) { 
            if (optPassword != null && optPassword.length() > 1) {
                return Site.login(userName, optPassword, '/apex/RegistrationComplete');
            }
            else {
                PageReference page = System.Page.Confirmation;
                page.setRedirect(true);
                return page;
                return null;
            }
        }
        return null;
    }


    private boolean isValidPassword() {
        return optPassword == optConfirmPassword;
    }
    
    /********************************************************************************************
        Purpose:  method to open community if user has session otherwise redirects to login page
    ********************************************************************************************/
    public PageReference forwardToStartPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return Network.forwardToAuthPage(null);
        }
        else{
            return Network.communitiesLanding();
        }
    }

    /********************************************************************************************
        Purpose:  Method to check session on initial load
    ********************************************************************************************/
    public PageReference checkSession() {
        if(UserInfo.getUserType() == 'Guest'){
            return null;
        }else{
            return Network.communitiesLanding();
        }
    }

    /********************************************************************************************
        Purpose:  method to login into community
    ********************************************************************************************/
    public PageReference login() {
    
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        if(startUrl == null) startUrl = '/apex/Home';
        
        String message = AppsHelper.checkUsername(username);
        if(String.isNotBlank(message)){
            throwError(message);
            return null;
        }

        PageReference pr = Site.login(username, password, startUrl);
        return pr;
    }


    public PageReference openForgotPassword(){
        PageReference pg = Page.ForgotPassword;
        pg.setRedirect(true);
        return pg;
    }



    /********************************************************************************************
        Purpose:   Method for forgot password
    ********************************************************************************************/
    public PageReference forgotPassword() {
        String message = AppsHelper.checkUsername(username);
        if(String.isNotBlank(message)){
            throwError(message);
            return null;
        }

        String doesNotExist = AppsHelper.isUsernameExist(username);
        if(String.isBlank(doesNotExist)){
            success = Site.forgotPassword(username); 
            if(success){
                PageReference pr = Page.Confirmation;
                pr.setRedirect(true);
                return pr;
            }else{    
                return null;
            }
        }else{
            throwError(doesNotExist);
            return null;
        }
    }

    /********************************************************************************************
        Purpose:  Method to change user's password
    ********************************************************************************************/
    public PageReference changePassword() {
        String message = AppsHelper.checkPasswords(oldpassword, newPassword, verifyNewPassword);
        if(String.isNotBlank(message)){
            throwError(message);
            return null;
        }
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);   
    }  
    
    public PageReference openHome(){
        PageReference pg = Page.Home;
        return pg;
    }


    /**
        UTILITY FUNCIONs
    **/
   
    /********************************************************************************************
        Purpose:  Adds exception to pages
    ********************************************************************************************/
    private static Boolean throwError(String errorMsg){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
        return true;
    }   
    
}