from cryptography.fernet import Fernet
import sys
try:
    from decoder_key import key
except:
    pass

def decrypt(password):
    cipher_suite = Fernet(key)
    password = cipher_suite.decrypt(password)
    return password.decode()

if __name__ == "__main__":
    password = sys.argv[1]
    key = Fernet.generate_key()
    f = open("decoder_key.py","w")
    f.write("key = "+str(key))
    f.close()
    password = password.encode()
    cipher_suite = Fernet(key)
    encrypted = cipher_suite.encrypt(password)
    f = open("secret.py","a")
    f.write("spotify_pass = "+str(encrypted))
    f.close()