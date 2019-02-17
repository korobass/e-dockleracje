#!/bin/bash
#
# e-Dockleracje -- zdokeryzowane e-Deklaracje
# Copyright (C) 2015 Michał "rysiek" Woźniak <rysiek@hackerspace.pl>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# upewniamy się, że działamy jako wrapper.sh, a więc już w dockerze
if [[ `basename $0` != 'wrapper.sh' ]]; then
  echo -ne '\n\nTen skrypt używany jest wyłącznie wewnątrz kontenera dockera;\njeśli chcesz uruchomić e-Deklaracje w dockerze,\nużyj skryptu edeklaracje.sh\n\n'
  exit 1
fi

# użytkownik i takie tam
groupadd -g "$EDEKLARACJE_GID" "$EDEKLARACJE_GROUP"
useradd -d "$EDEKLARACJE_HOME" -u "$EDEKLARACJE_UID" -g "$EDEKLARACJE_GID" -s /bin/bash "$EDEKLARACJE_USER"
mkdir -p "$EDEKLARACJE_HOME"

# akceptacja licencji Adobe Reader
mkdir -p $EDEKLARACJE_HOME/.adobe/Acrobat/9.0/Preferences
echo "<</AVPrivate [/c <<     /ChooseLangAtStartup [/b false]
        /EULAAcceptanceTime [/i 1]
        /SplashDisplayedAtStartup [/b false]
        /UnixLanguageStartup [/i 4542037]
        /showEULA [/b false]
>>]
>>" > $EDEKLARACJE_HOME/.adobe/Acrobat/9.0/Preferences/reader_prefs

chown -R "$EDEKLARACJE_UID":"$EDEKLARACJE_GID" "$EDEKLARACJE_HOME"

# ustawienie adresu ip hosta do CUPS
sed -i "s/HOST_IP/$HOST_IP/" /etc/cups/client.conf

cat > /tmp/certyfikaty.crt <<EOL
-----BEGIN CERTIFICATE-----
MIIDxTCCAq2gAwIBAgIQAqxcJmoLQJuPC3nyrkYldzANBgkqhkiG9w0BAQUFADBs
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSswKQYDVQQDEyJEaWdpQ2VydCBIaWdoIEFzc3VyYW5j
ZSBFViBSb290IENBMB4XDTA2MTExMDAwMDAwMFoXDTMxMTExMDAwMDAwMFowbDEL
MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
LmRpZ2ljZXJ0LmNvbTErMCkGA1UEAxMiRGlnaUNlcnQgSGlnaCBBc3N1cmFuY2Ug
RVYgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMbM5XPm
+9S75S0tMqbf5YE/yc0lSbZxKsPVlDRnogocsF9ppkCxxLeyj9CYpKlBWTrT3JTW
PNt0OKRKzE0lgvdKpVMSOO7zSW1xkX5jtqumX8OkhPhPYlG++MXs2ziS4wblCJEM
xChBVfvLWokVfnHoNb9Ncgk9vjo4UFt3MRuNs8ckRZqnrG0AFFoEt7oT61EKmEFB
Ik5lYYeBQVCmeVyJ3hlKV9Uu5l0cUyx+mM0aBhakaHPQNAQTXKFx01p8VdteZOE3
hzBWBOURtCmAEvF5OYiiAhF8J2a3iLd48soKqDirCmTCv2ZdlYTBoSUeh10aUAsg
EsxBu24LUTi4S8sCAwEAAaNjMGEwDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQF
MAMBAf8wHQYDVR0OBBYEFLE+w2kD+L9HAdSYJhoIAu9jZCvDMB8GA1UdIwQYMBaA
FLE+w2kD+L9HAdSYJhoIAu9jZCvDMA0GCSqGSIb3DQEBBQUAA4IBAQAcGgaX3Nec
nzyIZgYIVyHbIUf4KmeqvxgydkAQV8GK83rZEWWONfqe/EW1ntlMMUu4kehDLI6z
eM7b41N5cdblIZQB2lWHmiRk9opmzN6cN82oNLFpmyPInngiK3BD41VHMWEZ71jF
hS9OMPagMRYjyOfiZRYzy78aG6A9+MpeizGLYAiJLQwGXFK3xPkKmNEVX58Svnw2
Yzi9RKR/5CYrCsSXaQ3pjOLAEFe4yHYSkVXySGnYvCoCWw9E1CAx2/S6cCZdkGCe
vEsXCS+0yx5DaMkHJ8HSXPfqIbloEpw8nL+e/IBcm2PN7EeqJSdnoDfzAIJ9VNep
+OkuE6N36B9K
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEojCCA4qgAwIBAgIQA/7vG7W2SDSaIJUPi8aXUzANBgkqhkiG9w0BAQsFADBs
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSswKQYDVQQDEyJEaWdpQ2VydCBIaWdoIEFzc3VyYW5j
ZSBFViBSb290IENBMB4XDTE3MTEwNjEyMjI0NloXDTI3MTEwNjEyMjI0NlowYTEL
MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
LmRpZ2ljZXJ0LmNvbTEgMB4GA1UEAxMXR2VvVHJ1c3QgRVYgUlNBIENBIDIwMTgw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMHEZtLyqMmwFteOLrh+fy
Nso8PDp2wa60VzzJU50Xnh5u0J3enXoseXERhyu+M+twXDMu33luqy4AJO7yLO+y
iQw83xGGHmct7nifbf7xGOpC8NLP2Pz4bq/JfW+BWHVUS2j2mfOrVUSOaFuzjr9m
08eHh0UgdvmhUgwvov6E7E8Db4+5Mf3yF2KUaNHHCSOQPmN6rw7v79PrqaSI9usc
1tbjE6aIIcDbR2ORhMIubidx+4pj4uMaf/btEeX/ykfsdgqJYfL+Kk4OmwL9vJ6W
pWe93YMu0E/xCA8rgK8KU5D9RZEpzejTVhVRGI+fuddQA8U4aV6P2sCrRoS2kZxR
AgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUypJnUmHervy6Iit/HIdMJftvmVgwHwYD
VR0jBBgwFoAUsT7DaQP4v0cB1JgmGggC72NkK8MwDgYDVR0PAQH/BAQDAgGGMB0G
A1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEA
MDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNl
cnQuY29tMEsGA1UdHwREMEIwQKA+oDyGOmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
bS9EaWdpQ2VydEhpZ2hBc3N1cmFuY2VFVlJvb3RDQS5jcmwwPQYDVR0gBDYwNDAy
BgRVHSAAMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9D
UFMwDQYJKoZIhvcNAQELBQADggEBAMKOez279PqxlaLhDi4xvQj5BrpidHx0sBBZ
DWtCnvvAbTOsZNORGjtLkQR4IFoZZt8QiJRjPsLdwzjx5Q9xjt+Xy8YiXo8JCWqB
v7eeGzmb9Vn3wMf7eH22K/M2PcpDG/AgNjzL9nbJZhpI+OHbk4ohiD/oovX9hyFG
2Ns0y80qGctffopsBzfTMxHC5TwNGWybPg6UAHgvQviitOpPlMkdPEcutSqsvEFc
L2x9f7ZbFIP2Ie0EcuVNgX6jFj7EKfKFHn8apJdtGhUJZq4mablNm+3ixPkdVr5f
71aaFFvfKi824S12PbLs+k5iSr7uE3taQB2yE1umOs9OJ4X9Yvk=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIGzDCCBbSgAwIBAgIQDcvSMztP6ybnPVXFkdTVJTANBgkqhkiG9w0BAQsFADBh
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSAwHgYDVQQDExdHZW9UcnVzdCBFViBSU0EgQ0EgMjAx
ODAeFw0xODAyMTkwMDAwMDBaFw0yMDAyMTkxMjAwMDBaMIGtMRowGAYDVQQPDBFH
b3Zlcm5tZW50IEVudGl0eTETMBEGCysGAQQBgjc8AgEDEwJQTDESMBAGA1UEBRMJ
MDAwMDAyMjE3MQswCQYDVQQGEwJQTDERMA8GA1UEBxMIV2Fyc3phd2ExHjAcBgNV
BAoTFU1pbmlzdGVyc3R3byBGaW5hbnNvdzEmMCQGA1UEAxMdYnJhbWthLmUtZGVr
bGFyYWNqZS5tZi5nb3YucGwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQCsobTLhpJxG1MIkFQg0O4ycRPM96N76YDFmza0JjQy2SboXOBI8ESaVqQoIXbD
0tceOkDFYVGWwjY5+m8BNzDS2e7gBSKXmbA9WhAAP1WR0frhCT4buv1Mko9Dfmfg
AybrSFqjNYUCn1mJ/smtSO2otwYZug5PL0cYLQTYW0qrG4a+5dtq1QUUzYzEKKJo
dQnaPzvcctfEAbGSB4FMHSgGtO9FtEVIijoD/8RsYefmhHtz3RJXWkeEdGvaJCTs
He5niaLu7YqRxwRn8sidaFdMfMQD/dWm24vShDLvNZmW9CWjyXqOKY4cp3EGNf9W
mwlRDXCovZH84Hx3LVo47g21AgMBAAGjggMxMIIDLTAfBgNVHSMEGDAWgBTKkmdS
Yd6u/LoiK38ch0wl+2+ZWDAdBgNVHQ4EFgQUQTHnBgE+KMORJrxvoL3GYLElZ78w
KAYDVR0RBCEwH4IdYnJhbWthLmUtZGVrbGFyYWNqZS5tZi5nb3YucGwwDgYDVR0P
AQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjBABgNVHR8E
OTA3MDWgM6Axhi9odHRwOi8vY2RwLmdlb3RydXN0LmNvbS9HZW9UcnVzdEVWUlNB
Q0EyMDE4LmNybDBLBgNVHSAERDBCMDcGCWCGSAGG/WwCATAqMCgGCCsGAQUFBwIB
FhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAcGBWeBDAEBMHcGCCsGAQUF
BwEBBGswaTAmBggrBgEFBQcwAYYaaHR0cDovL3N0YXR1cy5nZW90cnVzdC5jb20w
PwYIKwYBBQUHMAKGM2h0dHA6Ly9jYWNlcnRzLmdlb3RydXN0LmNvbS9HZW9UcnVz
dEVWUlNBQ0EyMDE4LmNydDAJBgNVHRMEAjAAMIIBfQYKKwYBBAHWeQIEAgSCAW0E
ggFpAWcAdQCkuQmQtBhYFIe7E6LMZ3AKPDWYBPkb37jjd80OyA3cEAAAAWGuq2ZE
AAAEAwBGMEQCIBGdI1Ii6Tc3bglVE/Qg80zi64yBMucwM9RgAMH0cP4xAiAZkf1k
T7YrHFsLY18yGsYIphfwtvSV9q9SN+TFPT+I/AB2AFYUBpov18Ls0/XhvUSyPsdG
drm8mRFcwO+UmFXWidDdAAABYa6rZhEAAAQDAEcwRQIhAKsOeNsp+X7XD/yTC03R
GOmjThKnaaUoxVU2KD4c4nV/AiALR3rXM4G7WX/2s4dojp3ZsFLZ0a7yLRrH40FX
+wY42wB2ALvZ37wfinG1k5Qjl6qSe0c4V5UKq1LoGpCWZDaOHtGFAAABYa6rZxAA
AAQDAEcwRQIgOiJ2TBoVPkpTihD/IENK5UiJRgF3QJnF4zFwwOEYyi8CIQCF9rMH
/T/vnX379Jwc3AFH6C77k7MaYP51S47QUcc/VDANBgkqhkiG9w0BAQsFAAOCAQEA
w8rVWMejsY27cRIa0sQZSmXwPCTYIt+0lBt5z2xOEPh0iHoRXK7YPLlVRITNmTub
+ztTjOQIv1sJQzkoXxVKn2SWgozHNleTTXkyURLL9waggSsdqBpM+NqeFfbCr/2o
nQpWOuIhL09Tu1LJc0vs+vMgCsn5FjeezbnEXs50mcVYFm7dWlShPoCC7oEiYjLc
PFQSlP0K3ibdU4MHUS+PVermaDSauE03yCs5ZKS4nRxIPzVC3HdjWJmmiCVu5WJu
UkN931VAHy9nKkEf+6fAz2c2Bq6vtzpo9n+JWTgJwds99giPnvv1cZpOxb4n2vyr
tjTHRAToU0evdbXBKE5mWA==
-----END CERTIFICATE-----
EOL

cat /tmp/certyfikaty.crt >> $EDEKLARACJE_HOME/.appdata/Adobe/AIR/Certs/curl-ca-bundle.crt

exec su - $EDEKLARACJE_USER -c "
# magic: http://www.linuxquestions.org/questions/linux-newbie-8/xlib-connection-to-0-0-refused-by-server-xlib-no-protocol-specified-152556/
# na wszelki wypadek -- jeśli gid/uid/username się zgadzają, to powinno niby wszystko działać...
#xauth add \$HOSTNAME/unix:0 $MIT_COOKIE
xauth add `xauth list :0`
# jedziemy!
/opt/e-Deklaracje/bin/e-Deklaracje
"
