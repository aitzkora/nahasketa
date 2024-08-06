def main():
    try :
        print("√4", compute_sqrt(ct.c_double(4.)))
        print("√-4", compute_sqrt(ct.c_double(-4.)))
    except:
        print("Whew!", sys.exc_info()[0])
        #print("I raised THE exception 😎!")

if __name__ == "__main__":
    main()
