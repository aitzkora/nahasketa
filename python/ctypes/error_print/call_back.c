#include <stdio.h>
#include <Python.h>

#if defined(_WIN32)
#  define CALL_BACK_EXPORT_API __declspec(dllexport)
#else
#  define CALL_BACK_EXPORT_API
#endif
typedef void (*pCallBack)(const char *);

CALL_BACK_EXPORT_API void setCallBack(pCallBack cb);
CALL_BACK_EXPORT_API void errorPrint(const char *str);

pCallBack one_pointer = NULL;
static PyObject *arg_less_than_zero = NULL;

void setCallBack(pCallBack cb)
{
   one_pointer = cb;
   arg_less_than_zero = PyErr_NewException("lib_call_back.CustomError", NULL, NULL);
}

void errorPrint(const char * str)
{
  /*printf("my address = %p", one_pointer);
  fflush(stdout);*/
  if (one_pointer) { 
  (*one_pointer)(str);
  }
  PyErr_SetString(arg_less_than_zero, "arg less than zero");
  PyErr_Occurred();
}
