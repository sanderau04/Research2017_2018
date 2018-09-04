function [outputArg1,outputArg2] = emailNotification(userEmail,time,filename)
%Use bot email (botmatlab34@gmail.com) to recieve email notifications of
%algorithm run finish
%   Change input variable 'userEmail' to current algorithm user email to
%   receive the email notification with subject "Algorithm Run Has
%   Finished" and printed specifications on run time and files analyzed in
%   the body
timeSec = mod(time,60);
timeMin = time/60;
msg = 'Your algorithm run analyzed ';
msg2 = ' files in ';
msg3 = ' minutes and ';
msg4 = ' seconds.';
timeMin = num2str(fix(timeMin));
timeSec = num2str(fix(timeSec));
if iscell(filename) == 1
    files = num2str(length(filename));
else
    files = num2str(1);
end
message = [msg files msg2 timeMin msg3 timeSec msg4];

myaddress = 'botmatlab34@gmail.com';
mypassword = 'matlab69';
setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
    'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(userEmail,'Algorithm Run Has Finished',message);
end

