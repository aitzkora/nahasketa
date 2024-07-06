#include <stdio.h>

#if defined(_WIN32)
#  define CALL_BACK_EXPORT_API __declspec(dllexport)
#else
#  define CALL_BACK_EXPORT_API
#endif
typedef void (*pCallBack)(const char *);

CALL_BACK_EXPORT_API void setCallBack(pCallBack cb);
CALL_BACK_EXPORT_API void errorPrint(const char *str);

pCallBack one_pointer = NULL;

void setCallBack(pCallBack cb)
{
   one_pointer = cb;
}

void errorPrint(const char * str)
{
  if (one_pointer) { 
  (*one_pointer)(str);
  }
}
