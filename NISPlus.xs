/* $Id: NISPlus.xs,v 1.10 1996/05/12 08:09:49 rik Exp rik $ */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <rpcsvc/nis.h>

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

char *
strndup(str, num)
char	*str;
int	num;
{
  char	*newstr = (char *)malloc(num);
  char	*pos = newstr;

  if (newstr)
  {
    while(num--) { *pos++ = *str++; }
  }
  return(newstr);
}

/*
static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}
*/

static double
constant(name, arg)
char	*name;
int	arg;
{
  errno = 0;
#ifdef FOLLOW_LINKS
  if (strEQ(name, "FOLLOW_LINKS"))
  {
    return FOLLOW_LINKS;
  }
#endif
#ifdef FOLLOW_PATH
  if (strEQ(name, "FOLLOW_PATH"))
  {
    return FOLLOW_PATH;
  }
#endif
#ifdef HARD_LOOKUP
  if (strEQ(name, "HARD_LOOKUP"))
  {
    return HARD_LOOKUP;
  }
#endif
#ifdef ALL_RESULTS
  if (strEQ(name, "ALL_RESULTS"))
  {
    return ALL_RESULTS;
  }
#endif
#ifdef NO_CACHE
  if (strEQ(name, "NO_CACHE"))
  {
    return NO_CACHE;
  }
#endif
#ifdef MASTER_ONLY
  if (strEQ(name, "MASTER_ONLY"))
  {
    return MASTER_ONLY;
  }
#endif
#ifdef EXPAND_NAME
  if (strEQ(name, "EXPAND_NAME"))
  {
    return EXPAND_NAME;
  }
#endif
#ifdef RETURN_RESULT
  if (strEQ(name, "RETURN_RESULT"))
  {
    return RETURN_RESULT;
  }
#endif
#ifdef ADD_OVERWRITE
  if (strEQ(name, "ADD_OVERWRITE"))
  {
    return ADD_OVERWRITE;
  }
#endif
#ifdef REM_MULTIPLE
  if (strEQ(name, "REM_MULTIPLE"))
  {
    return REM_MULTIPLE;
  }
#endif
#ifdef MOD_SAMEOBJ
  if (strEQ(name, "MOD_SAMEOBJ"))
  {
    return MOD_SAMEOBJ;
  }
#endif
#ifdef ADD_RESERVED
  if (strEQ(name, "ADD_RESERVED"))
  {
    return ADD_RESERVED;
  }
#endif
#ifdef REM_RESERVED
  if (strEQ(name, "REM_RESERVED"))
  {
    return REM_RESERVED;
  }
#endif
#ifdef MOD_RESERVED
  if (strEQ(name, "MOD_RESERVED"))
  {
    return MOD_RESERVED;
  }
#endif
  if (strEQ(name, "BOGUS_OBJ"))
  {
    return BOGUS_OBJ;
  }
  if (strEQ(name, "NO_OBJ"))
  {
    return NO_OBJ;
  }
  if (strEQ(name, "DIRECTORY_OBJ"))
  {
    return DIRECTORY_OBJ;
  }
  if (strEQ(name, "GROUP_OBJ"))
  {
    return GROUP_OBJ;
  }
  if (strEQ(name, "TABLE_OBJ"))
  {
    return TABLE_OBJ;
  }
  if (strEQ(name, "ENTRY_OBJ"))
  {
    return ENTRY_OBJ;
  }
  if (strEQ(name, "LINK_OBJ"))
  {
    return LINK_OBJ;
  }
  if (strEQ(name, "PRIVATE_OBJ"))
  {
    return PRIVATE_OBJ;
  }
#ifdef TA_BINARY
  if (strEQ(name, "TA_BINARY"))
  {
    return TA_BINARY;
  }
#endif
#ifdef TA_CRYPT
  if (strEQ(name, "TA_CRYPT"))
  {
    return TA_CRYPT;
  }
#endif
#ifdef TA_XDR
  if (strEQ(name, "TA_XDR"))
  {
    return TA_XDR;
  }
#endif
#ifdef TA_SEARCHABLE
  if (strEQ(name, "TA_SEARCHABLE"))
  {
    return TA_SEARCHABLE;
  }
#endif
#ifdef TA_CASE
  if (strEQ(name, "TA_CASE"))
  {
    return TA_CASE;
  }
#endif
#ifdef TA_MODIFIED
  if (strEQ(name, "TA_MODIFIED"))
  {
    return TA_MODIFIED;
  }
#endif
#ifdef TA_ASN1
  if (strEQ(name, "TA_ASN1"))
  {
    return TA_ASN1;
  }
#endif

  errno = EINVAL;
  return 0;

not_there:
  errno = ENOENT;
  return 0;
}

nis_result *
lookup(path)
nis_name	path;
{
  nis_result	*res;

  res = nis_lookup(path, 0);
  switch (NIS_RES_NUMOBJ(res))
  {
    case 1:
      return(res);
      break;
    case 0:
/*    warn("error in nis_lookup for %s: %s", path, nis_sperrno(res->status));*/
      return (nis_result *)NULL;
      break;
    default:
      croak("nis_lookup returned %d objects ", NIS_RES_NUMOBJ(res));
  }
}

void
print_nisresult(res)
nis_result	*res;
{
  int		num, num2;
  objdata	*object;

  printf("NIS Result:\n");
  printf("status: %d\n", res->status);
  printf("objects->objects_len: %d\n", NIS_RES_NUMOBJ(res));
  for (num=0; num<NIS_RES_NUMOBJ(res); num++)
  {
    printf("  object %d:\n", num);
    printf("    zo_oid: %lu %lu \n",
      NIS_RES_OBJECT(res)->zo_oid.ctime,
      NIS_RES_OBJECT(res)->zo_oid.mtime);
    printf("    zo_name: %s\n", NIS_RES_OBJECT(res)->zo_name);
    printf("    zo_owner: %s\n", NIS_RES_OBJECT(res)->zo_owner);
    printf("    zo_group: %s\n", NIS_RES_OBJECT(res)->zo_group);
    printf("    zo_domain: %s\n", NIS_RES_OBJECT(res)->zo_domain);
    printf("    zo_access: %lu\n", NIS_RES_OBJECT(res)->zo_access);
    printf("    zo_ttl: %lu\n", NIS_RES_OBJECT(res)->zo_ttl);
    printf("    object_type: (%d) ", __type_of(NIS_RES_OBJECT(res)));
    switch (__type_of(NIS_RES_OBJECT(res)))
    {
      case BOGUS_OBJ:
        printf("BOGUS_OBJ\n");
        break;
      case NO_OBJ:
        printf("NO_OBJ\n");
        break;
      case DIRECTORY_OBJ:
        printf("DIRECTORY_OBJ\n");
        break;
      case GROUP_OBJ:
        printf("GROUP_OBJ\n");
        break;
      case TABLE_OBJ:
        printf("TABLE_OBJ\n");
        break;
      case ENTRY_OBJ:
      {
        struct	entry_obj	*entry =
          &NIS_RES_OBJECT(res)->zo_data.objdata_u.en_data;

        printf("ENTRY_OBJ\n");
        printf("      en_type: %s\n", entry->en_type);
        printf("      en_cols_len: %u\n", entry->en_cols.en_cols_len);
        for (num2=0; num2<entry->en_cols.en_cols_len; num2++)
        {
          printf("        ec_flags: %lu\n",
            entry->en_cols.en_cols_val[num2].ec_flags);
          printf("        ec_value.ec_value_len: %u\n",
            ENTRY_LEN(NIS_RES_OBJECT(res), num2));
          printf("        ec_value.ec_value_val: %s\n",
            ENTRY_VAL(NIS_RES_OBJECT(res), num2));
        }
        break;
      }
      case LINK_OBJ:
        printf("LINK_OBJ\n");
        break;
      case PRIVATE_OBJ:
        printf("PRIVATE_OBJ\n");
        break;
      default:
        printf("UNKNOWN\n");
        break;
    }
  }
  printf("cookie (%d): ", res->cookie.n_len);
  for (num=0; num<res->cookie.n_len; num++)
  {
    printf(" %02x", res->cookie.n_bytes[num]);
  }
  printf("\nzticks: %lu\n", res->zticks);
  printf("dticks: %lu\n", res->dticks);
  printf("aticks: %lu\n", res->aticks);
  printf("cticks: %lu\n", res->cticks);
}

#define NISRESULT_ENTRY(RES) do						\
{									\
  u_int			num, num2;					\
  struct entry_obj	*entry;						\
									\
  EXTEND(sp, NIS_RES_NUMOBJ(RES));					\
									\
  for (num=0; num<NIS_RES_NUMOBJ(RES); num++)				\
  {									\
    AV	*nisentry = newAV();						\
									\
    if (NIS_RES_OBJECT(RES)[num].zo_data.zo_type != ENTRY_OBJ)		\
    {									\
      croak("not an entry object in nisresult_entry");			\
    }									\
									\
    entry = &NIS_RES_OBJECT(RES)[num].EN_data;				\
									\
    for (num2=0; num2<entry->en_cols.en_cols_len; num2++)		\
    {									\
      if (entry->en_cols.en_cols_val[num2].ec_value.ec_value_len > 0)	\
      {									\
        av_push(nisentry, newSVpv(					\
          entry->en_cols.en_cols_val[num2].ec_value.ec_value_val,	\
          entry->en_cols.en_cols_val[num2].ec_value.ec_value_len-1));	\
      }									\
      else								\
      {									\
        av_push(nisentry, &sv_undef);	 				\
      }									\
    }									\
									\
    PUSHs(newRV((SV *)nisentry));					\
  }									\
} while(0)

#define NISRESULT_NAMES(RES) do						\
{									\
  u_int			num, num2;					\
  struct entry_obj	*entry;						\
									\
  EXTEND(sp, NIS_RES_NUMOBJ(RES));					\
									\
  for (num=0; num<NIS_RES_NUMOBJ(RES); num++)				\
  {									\
    if (NIS_RES_OBJECT(RES)[num].zo_data.zo_type != ENTRY_OBJ)		\
    {									\
      croak("not an entry object in nisresult_names");			\
    }									\
									\
    PUSHs(sv_2mortal(newSVpv(						\
      NIS_RES_OBJECT(RES)[num].zo_name,					\
      strlen(NIS_RES_OBJECT(RES)[num].zo_name))));			\
  }									\
} while(0)

HV	*nisresult_info(res)
nis_result	*res;
{
  char		buf[256];
  nis_object	*object;
  SV		*type;
  HV		*ret;
  
  ret = newHV();
  object = NIS_RES_OBJECT(res);
  sprintf(buf, "%8lx%8lx", object->zo_oid.ctime, object->zo_oid.mtime);
  hv_store(ret, "oid", 3, newSVpv(buf, strlen(buf)), 0);
  hv_store(ret, "name", 4,
    newSVpv(object->zo_name, strlen(object->zo_name)), 0);
  hv_store(ret, "owner", 5,
    newSVpv(object->zo_owner, strlen(object->zo_owner)), 0);
  hv_store(ret, "group", 5,
    newSVpv(object->zo_group, strlen(object->zo_group)), 0);
  hv_store(ret, "domain", 6,
    newSVpv(object->zo_domain, strlen(object->zo_domain)), 0);
  hv_store(ret, "name", 4,
    newSVpv(object->zo_name, strlen(object->zo_name)), 0);
  hv_store(ret, "access", 6, newSViv(object->zo_access), 0);
  hv_store(ret, "ttl", 3, newSViv(object->zo_ttl), 0);
  hv_store(ret, "type", 4, newSViv(object->zo_data.zo_type), 0);
  type = newSViv(object->zo_data.zo_type);
  hv_store(ret, "type", 4, type, 0);

  switch (object->zo_data.zo_type)
  {
    case BOGUS_OBJ:
      sv_setpv(type, "BOGUS");
      break;
    case NO_OBJ:
      sv_setpv(type, "NO");
      break;
    case DIRECTORY_OBJ:
      sv_setpv(type, "DIRECTORY");
      break;
    case GROUP_OBJ:
      sv_setpv(type, "GROUP");
      break;
    case TABLE_OBJ:
    {
      HV		*colflags, *colrights;
      AV		*cols;
      int		col;
      unsigned char	sep[1];

      sv_setpv(type, "TABLE");
      hv_store(ret, "ta_type", 7,
        newSVpv(object->TA_data.ta_type, strlen(object->TA_data.ta_type)), 0);
      hv_store(ret, "ta_maxcol", 9, newSViv(object->TA_data.ta_maxcol), 0);
      sep[0] = object->TA_data.ta_sep;
      hv_store(ret, "ta_sep", 6, newSVpv((char *)sep, 1), 0);
      colflags = newHV();
      colrights = newHV();
      cols = newAV();
      for (col=0; col<object->TA_data.ta_cols.ta_cols_len; col++)
      {
        av_push(cols, newSVpv(object->TA_data.ta_cols.ta_cols_val[col].tc_name,
          strlen(object->TA_data.ta_cols.ta_cols_val[col].tc_name)));
        hv_store(colflags, object->TA_data.ta_cols.ta_cols_val[col].tc_name,
          strlen(object->TA_data.ta_cols.ta_cols_val[col].tc_name),
          newSViv(object->TA_data.ta_cols.ta_cols_val[col].tc_flags), 0);
        hv_store(colrights, object->TA_data.ta_cols.ta_cols_val[col].tc_name,
          strlen(object->TA_data.ta_cols.ta_cols_val[col].tc_name),
          newSViv(object->TA_data.ta_cols.ta_cols_val[col].tc_rights), 0);
      }
      hv_store(ret, "ta_cols_flags", 13, newRV((SV *)colflags), 0);
      hv_store(ret, "ta_cols_rights", 14, newRV((SV *)colrights), 0);
      hv_store(ret, "ta_cols", 7, newRV((SV *)cols), 0);
      hv_store(ret, "ta_path", 7,
        newSVpv(object->TA_data.ta_path, strlen(object->TA_data.ta_path)), 0);
      break;
    }
    case ENTRY_OBJ:
    {
      AV		*colflags, *cols;
      int		col;
      unsigned char	sep[1];

      sv_setpv(type, "ENTRY");
      hv_store(ret, "en_type", 7,
        newSVpv(object->EN_data.en_type, strlen(object->EN_data.en_type)), 0);
      colflags = newAV();
      cols = newAV();
      for (col=0; col<object->EN_data.en_cols.en_cols_len; col++)
      {
        av_push(cols, newSVpv(
          object->EN_data.en_cols.en_cols_val[col].ec_value.ec_value_val,
          object->EN_data.en_cols.en_cols_val[col].ec_value.ec_value_len));
        av_push(colflags,
          newSViv(object->EN_data.en_cols.en_cols_val[col].ec_flags));
      }
      hv_store(ret, "en_cols_flags", 13, newRV((SV *)colflags), 0);
      hv_store(ret, "en_cols", 7, newRV((SV *)cols), 0);
      break;
    }
    case LINK_OBJ:
      sv_setpv(type, "LINK");
      break;
    case PRIVATE_OBJ:
      sv_setpv(type, "PRIVATE");
      break;
    default:
      sv_setpv(type, "UNKNOWN");
      break;
  }
  SvPOK_on(type);
  return(ret);
}

void
fill_entry(table, entry, data, add)
nis_result	*table;
SV		*data;
nis_object	*entry;
int		add;
{
  table_obj	*ta;
  int		pos, set;
  HE		*he;
  SV		**val;

  ta = &(NIS_RES_OBJECT(table)[0].TA_data);
  if (add)
  {
    entry->zo_data.zo_type = ENTRY_OBJ;
    entry->EN_data.en_cols.en_cols_len = ta->ta_cols.ta_cols_len;
    entry->zo_data.objdata_u.en_data.en_type = ta->ta_type;
    if ((entry->EN_data.en_cols.en_cols_val =
      (entry_col *)malloc(sizeof(entry_col) *
        entry->EN_data.en_cols.en_cols_len)) == (entry_col *)NULL)
    {
      croak("can't allocate memory for en_data");
    }
  }
  for (pos=0; pos<ta->ta_cols.ta_cols_len; pos++)
  {
    val = hv_fetch((HV *)SvRV(data), ta->ta_cols.ta_cols_val[pos].tc_name,
      strlen(ta->ta_cols.ta_cols_val[pos].tc_name), 0);
    set = 0;
    if (val != (SV **)NULL)
    {
      if (SvPOK(*val))
      {
        char	*a;
        unsigned int l;

        a = SvPV(*val, l);
        ENTRY_VAL(entry, pos) = strndup(a, l+1);
        ENTRY_VAL(entry, pos)[l] = '\0';
        ENTRY_LEN(entry, pos) = l+1;
        entry->EN_data.en_cols.en_cols_val[pos].ec_flags = EN_MODIFIED;
        set++;
      }
    }
    if (!set)
    {
      if (add)
      {
        ENTRY_VAL(entry, pos) = "";
        ENTRY_LEN(entry, pos) = 0;
        entry->EN_data.en_cols.en_cols_val[pos].ec_flags = EN_MODIFIED;
      }
    }
  }
}

MODULE = Net::NISPlus	PACKAGE = Net::NISPlus

double
constant(name,arg)
	char *		name
	int		arg

void
nis_getnames(name)
  nis_name	name
  PPCODE:
  {
    nis_name *	names;
    nis_name *	names_first;

    names_first = names = nis_getnames(name);
    while(*names != NULL)
    {
      XPUSHs(sv_2mortal(newSVpv(*names, strlen(*names))));
      names++;
    }
    nis_freenames(names_first);
  }

nis_name
nis_leaf_of(name)
  nis_name	name

nis_name
nis_name_of(name)
  nis_name	name

nis_name
nis_domain_of(name)
  nis_name	name

name_pos
nis_dir_cmp(name1, name2)
  nis_name	name1
  nis_name	name2

nis_name
nis_local_directory()

nis_name
nis_local_host()

nis_name
nis_local_group()

nis_name
nis_local_principal()

void
nis_add_entry(name, data)
  nis_name	name
  SV *		data
  PPCODE:
  {
    nis_result	*table;
    nis_result	*res;
    nis_object	entry;

    table = lookup(name);
    if (table == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
      fill_entry(table, &entry, data, 1);
      entry.zo_name = "";
      entry.zo_owner = nis_local_principal();
      entry.zo_group = nis_local_group();
      entry.zo_domain = "";
      entry.zo_access = DEFAULT_RIGHTS;
      entry.zo_ttl = NIS_RES_OBJECT(table)[0].zo_ttl;
      if ((res = nis_add_entry(name, &entry, 0)) == (nis_result *)NULL)
        XPUSHs(sv_newmortal());
      else
      {
        XPUSHs(sv_2mortal(newSViv(res->status)));
        nis_freeresult(res);
      }
      nis_freeresult(table);
    }
  }

void
nis_remove_entry(name, flags)
  nis_name	name
  unsigned long	flags
  PPCODE:
  {
    nis_result	*res;

    if ((res = nis_remove_entry(name, (nis_object *)NULL, flags)) ==
      (nis_result *)NULL)
      XPUSHs(sv_newmortal());
    else
    {
      XPUSHs(sv_2mortal(newSViv(res->status)));
      nis_freeresult(res);
    }
  }

void
nis_modify_entry(name, data, flags)
  nis_name	name
  SV *		data
  unsigned long	flags
  PPCODE:
  {
    nis_result	*table;
    nis_result	*res, *lres;
    nis_object	*entry;
    nis_name	tname;
    int		num;

# first, we get a reference to the table object.  This is used for
# the column names for fill_entry()
    if ((tname = (nis_name)strrchr((char *)name, ',')) == (char *)NULL)
      tname = name;
    else tname++;
#warn("looking up %s\n", tname);
    table = lookup(tname);
    if (table == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
#warn("about to nis_list on %s\n", name);
# next, we grab a list of entries which match the search pattern
      lres=nis_list(name, 0, (int(*)())NULL, (void *)NULL);
 
      if (lres == (nis_result *)NULL)
      {
        croak("nis_list returned NULL");
      }
      if (!lres->status)
      {
# now we enumerate over the entries, changing the fields which changed
#warn("found %d items\n", NIS_RES_NUMOBJ(lres));
        for (num=0; num<NIS_RES_NUMOBJ(lres); num++)
        {
          AV  *nisentry = newAV();

          if (NIS_RES_OBJECT(lres)[num].zo_data.zo_type != ENTRY_OBJ)
          {
            croak("not an entry object in nis_modify_entry");
          }

          entry = &NIS_RES_OBJECT(lres)[num];
#warn("filling entry #%d\n", num);
          fill_entry(table, entry, data, 0);
#warn("nis_modify_entry(%s,...,...)\n", name);
          if ((res = nis_modify_entry(name, entry, flags)) == (nis_result *)NULL)
            XPUSHs(sv_newmortal());
          else
          {
#warn("operation succeeded\n");
            XPUSHs(sv_2mortal(newSViv(res->status)));
#warn("about to freeresult(res) - %lx\n", res);
            nis_freeresult(res);
          }
        }
      }
      else
      {
        warn("status returned from nis_list = %d\n", lres->status);
      }
#warn("about to freeresult(lres) - %lx\n", lres);
      nis_freeresult(lres);
    }
#warn("about to freeresult(table) - %lx\n", table);
    nis_freeresult(table);
  }


# list the names of the table entries
void
name_list(name)
  nis_name	name
  PPCODE:
  {
    nis_result	*res;
    
    res = nis_list(name, 0, (int(*)())NULL, (void *)NULL);

    if (res == (nis_result *)NULL)
    {
      croak("nis_list returned NULL");
    }
    XPUSHs(sv_2mortal(newSViv(res->status)));
    if (!res->status)
    {
      NISRESULT_NAMES(res);
    }
    nis_freeresult(res);
  }

# return an array of the contents of the table entries
void
entry_list(name)
  nis_name	name
  PPCODE:
  {
    nis_result	*res;
    
    res=nis_list(name, MASTER_ONLY, (int(*)())NULL, (void *)NULL);

    if (res == (nis_result *)NULL)
    {
      croak("nis_list returned NULL");
    }
    XPUSHs(sv_2mortal(newSViv(res->status)));
    if (!res->status)
    {
      NISRESULT_ENTRY(res);
    }
    nis_freeresult(res);
  }

void
nis_first_entry(name)
  nis_name	name
  PPCODE:
  {
    nis_result	*res;
    u_int	num;
    
    res=nis_first_entry(name);

    if (res == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
      XPUSHs(sv_2mortal(newSViv(res->status)));
      if (!res->status)
      {
        XPUSHs(sv_2mortal(newSVpv(res->cookie.n_bytes, res->cookie.n_len)));
        NISRESULT_ENTRY(res);
      }
      nis_freeresult(res);
    }
  }

void
nis_next_entry(name, cookie)
  nis_name	name
  netobj	cookie
  PPCODE:
  {
    nis_result	*res;
    u_int	num;
    
    res=nis_next_entry(name, &cookie);

    if (res == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
      XPUSHs(sv_2mortal(newSViv(res->status)));
      if (!res->status)
      {
        XPUSHs(sv_2mortal(newSVpv(res->cookie.n_bytes, res->cookie.n_len)));
        NISRESULT_ENTRY(res);
      }
      nis_freeresult(res);
    }
  }

char *
nis_sperrno(status)
  nis_error	status

void
nis_perror(status, label)
  nis_error	status
  char *	label

void
nis_lerrnor(status, label)
  nis_error	status
  char *	label

void
table_info(path)
  nis_name	path
  PPCODE:
  {
    nis_result	*res;

    res = lookup(path);
    if (res == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
      XPUSHs(sv_2mortal(newSViv(res->status)));
      XPUSHs(sv_2mortal(newRV((SV *)nisresult_info(res))));
      nis_freeresult(res);
    }
  }

void
obj_type(path)
  nis_name	path
  PPCODE:
  {
    nis_result	*res;

#    warn("obj_type: %s\n", path);
    res = lookup(path);
#    warn("res: %lx\n", res);
    if (res == (nis_result *)NULL) XPUSHs(sv_newmortal());
    else
    {
      XPUSHs(sv_2mortal(newSViv(NIS_RES_OBJECT(res)[0].zo_data.zo_type)));
      nis_freeresult(res);
    }
  }
