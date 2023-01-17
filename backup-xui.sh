read -p 'Bot token: ' tk
read -p 'Chat id: ' chatid
read -p 'Caption (for example, your domain, to identify the database file more easily): ' caption

cat >/root/ac.php <<EOL
<?php


  function Bot(\$method, \$data = [])
    {
        \$url = 'https://api.telegram.org/bot${tk}/' . \$method;
       
        \$ch = curl_init();
        curl_setopt(\$ch, CURLOPT_URL, \$url);
        curl_setopt(\$ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt(\$ch, CURLOPT_POSTFIELDS, \$data);
        \$res = curl_exec(\$ch);
        curl_close(\$ch);
        if (curl_error(\$ch)) {
            return curl_error(\$ch);
        } else {
            return \$res;
        }

    }
    
        function sendDocument(\$chat_id, \$document, \$caption = null, \$parse = 'HTML')
    {
      
        return Bot('sendDocument', [
            'chat_id' => \$chat_id,
            'document' => \$document,
            'caption' => \$caption,
            'parse_mode' => \$parse,
        ]);
    }
 
  
    sendDocument(${chatid},new CURLFile('/etc/x-ui/x-ui.db'),'${caption}');
    sendDocument(${chatid},new CURLFile('/usr/local/x-ui/bin/config.json'),'${caption}');
EOL

sudo apt update
sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
echo | sudo add-apt-repository ppa:ondrej/php
sudo apt install php8.2 -y
sudo apt-get install php-curl -y
sudo chmod -R 777 /etc/x-ui/x-ui.db
sudo chmod -R 777 /usr/local/x-ui/bin/config.json

{ crontab -l -u root; echo '0 */6 * * * /usr/bin/php /root/ac.php >/dev/null 2>&1'; } | crontab -u root -
echo 'Done'