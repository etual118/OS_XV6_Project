
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 20             	sub    $0x20,%esp
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 6c                	jle    80 <main+0x80>
main(int argc, char *argv[])
  14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  17:	83 c3 04             	add    $0x4,%ebx
  1a:	be 01 00 00 00       	mov    $0x1,%esi
  1f:	90                   	nop
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  27:	00 
  28:	8b 03                	mov    (%ebx),%eax
  2a:	89 04 24             	mov    %eax,(%esp)
  2d:	e8 5d 03 00 00       	call   38f <open>
  32:	85 c0                	test   %eax,%eax
  34:	78 2b                	js     61 <main+0x61>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  36:	8b 13                	mov    (%ebx),%edx
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  43:	e8 54 00 00 00       	call   9c <wc>
    close(fd);
  48:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 23 03 00 00       	call   377 <close>
  for(i = 1; i < argc; i++){
  54:	46                   	inc    %esi
  55:	83 c3 04             	add    $0x4,%ebx
  58:	39 fe                	cmp    %edi,%esi
  5a:	75 c4                	jne    20 <main+0x20>
  }
  exit();
  5c:	e8 ee 02 00 00       	call   34f <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  61:	8b 03                	mov    (%ebx),%eax
  63:	89 44 24 08          	mov    %eax,0x8(%esp)
  67:	c7 44 24 04 dd 07 00 	movl   $0x7dd,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  76:	e8 1d 04 00 00       	call   498 <printf>
      exit();
  7b:	e8 cf 02 00 00       	call   34f <exit>
    wc(0, "");
  80:	c7 44 24 04 cf 07 00 	movl   $0x7cf,0x4(%esp)
  87:	00 
  88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8f:	e8 08 00 00 00       	call   9c <wc>
    exit();
  94:	e8 b6 02 00 00       	call   34f <exit>
  99:	66 90                	xchg   %ax,%ax
  9b:	90                   	nop

0000009c <wc>:
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	57                   	push   %edi
  a0:	56                   	push   %esi
  a1:	53                   	push   %ebx
  a2:	83 ec 3c             	sub    $0x3c,%esp
  inword = 0;
  a5:	31 db                	xor    %ebx,%ebx
  l = w = c = 0;
  a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  c3:	00 
  c4:	c7 44 24 04 e0 0a 00 	movl   $0xae0,0x4(%esp)
  cb:	00 
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	89 04 24             	mov    %eax,(%esp)
  d2:	e8 90 02 00 00       	call   367 <read>
  d7:	89 c6                	mov    %eax,%esi
  d9:	83 f8 00             	cmp    $0x0,%eax
  dc:	7e 51                	jle    12f <wc+0x93>
  de:	31 ff                	xor    %edi,%edi
  e0:	eb 1d                	jmp    ff <wc+0x63>
  e2:	66 90                	xchg   %ax,%ax
      if(strchr(" \r\t\n\v", buf[i]))
  e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  e8:	c7 04 24 ba 07 00 00 	movl   $0x7ba,(%esp)
  ef:	e8 20 01 00 00       	call   214 <strchr>
  f4:	85 c0                	test   %eax,%eax
  f6:	74 18                	je     110 <wc+0x74>
        inword = 0;
  f8:	31 db                	xor    %ebx,%ebx
    for(i=0; i<n; i++){
  fa:	47                   	inc    %edi
  fb:	39 f7                	cmp    %esi,%edi
  fd:	74 1f                	je     11e <wc+0x82>
      if(buf[i] == '\n')
  ff:	0f be 87 e0 0a 00 00 	movsbl 0xae0(%edi),%eax
 106:	3c 0a                	cmp    $0xa,%al
 108:	75 da                	jne    e4 <wc+0x48>
        l++;
 10a:	ff 45 e4             	incl   -0x1c(%ebp)
 10d:	eb d5                	jmp    e4 <wc+0x48>
 10f:	90                   	nop
      else if(!inword){
 110:	85 db                	test   %ebx,%ebx
 112:	75 14                	jne    128 <wc+0x8c>
        w++;
 114:	ff 45 e0             	incl   -0x20(%ebp)
        inword = 1;
 117:	b3 01                	mov    $0x1,%bl
    for(i=0; i<n; i++){
 119:	47                   	inc    %edi
 11a:	39 f7                	cmp    %esi,%edi
 11c:	75 e1                	jne    ff <wc+0x63>
 11e:	8b 45 dc             	mov    -0x24(%ebp),%eax
 121:	01 f8                	add    %edi,%eax
 123:	89 45 dc             	mov    %eax,-0x24(%ebp)
 126:	eb 94                	jmp    bc <wc+0x20>
      else if(!inword){
 128:	bb 01 00 00 00       	mov    $0x1,%ebx
 12d:	eb cb                	jmp    fa <wc+0x5e>
  if(n < 0){
 12f:	75 38                	jne    169 <wc+0xcd>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 131:	8b 45 0c             	mov    0xc(%ebp),%eax
 134:	89 44 24 14          	mov    %eax,0x14(%esp)
 138:	8b 45 dc             	mov    -0x24(%ebp),%eax
 13b:	89 44 24 10          	mov    %eax,0x10(%esp)
 13f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 142:	89 44 24 0c          	mov    %eax,0xc(%esp)
 146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 149:	89 44 24 08          	mov    %eax,0x8(%esp)
 14d:	c7 44 24 04 d0 07 00 	movl   $0x7d0,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	e8 37 03 00 00       	call   498 <printf>
}
 161:	83 c4 3c             	add    $0x3c,%esp
 164:	5b                   	pop    %ebx
 165:	5e                   	pop    %esi
 166:	5f                   	pop    %edi
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
    printf(1, "wc: read error\n");
 169:	c7 44 24 04 c0 07 00 	movl   $0x7c0,0x4(%esp)
 170:	00 
 171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 178:	e8 1b 03 00 00       	call   498 <printf>
    exit();
 17d:	e8 cd 01 00 00       	call   34f <exit>
 182:	66 90                	xchg   %ax,%ax

00000184 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	53                   	push   %ebx
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18e:	89 c2                	mov    %eax,%edx
 190:	8a 19                	mov    (%ecx),%bl
 192:	88 1a                	mov    %bl,(%edx)
 194:	42                   	inc    %edx
 195:	41                   	inc    %ecx
 196:	84 db                	test   %bl,%bl
 198:	75 f6                	jne    190 <strcpy+0xc>
    ;
  return os;
}
 19a:	5b                   	pop    %ebx
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	8b 55 08             	mov    0x8(%ebp),%edx
 1a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ab:	0f b6 02             	movzbl (%edx),%eax
 1ae:	0f b6 19             	movzbl (%ecx),%ebx
 1b1:	84 c0                	test   %al,%al
 1b3:	75 14                	jne    1c9 <strcmp+0x29>
 1b5:	eb 1d                	jmp    1d4 <strcmp+0x34>
 1b7:	90                   	nop
    p++, q++;
 1b8:	42                   	inc    %edx
 1b9:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 1bc:	0f b6 02             	movzbl (%edx),%eax
 1bf:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1c3:	84 c0                	test   %al,%al
 1c5:	74 0d                	je     1d4 <strcmp+0x34>
    p++, q++;
 1c7:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 1c9:	38 d8                	cmp    %bl,%al
 1cb:	74 eb                	je     1b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1cd:	29 d8                	sub    %ebx,%eax
}
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	90                   	nop
  while(*p && *p == *q)
 1d4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1d6:	29 d8                	sub    %ebx,%eax
}
 1d8:	5b                   	pop    %ebx
 1d9:	5e                   	pop    %esi
 1da:	5d                   	pop    %ebp
 1db:	c3                   	ret    

000001dc <strlen>:

uint
strlen(char *s)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e2:	80 39 00             	cmpb   $0x0,(%ecx)
 1e5:	74 10                	je     1f7 <strlen+0x1b>
 1e7:	31 d2                	xor    %edx,%edx
 1e9:	8d 76 00             	lea    0x0(%esi),%esi
 1ec:	42                   	inc    %edx
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f3:	75 f7                	jne    1ec <strlen+0x10>
    ;
  return n;
}
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1f7:	31 c0                	xor    %eax,%eax
}
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
 1fb:	90                   	nop

000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
 200:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 203:	89 d7                	mov    %edx,%edi
 205:	8b 4d 10             	mov    0x10(%ebp),%ecx
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	fc                   	cld    
 20c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 20e:	89 d0                	mov    %edx,%eax
 210:	5f                   	pop    %edi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	90                   	nop

00000214 <strchr>:

char*
strchr(const char *s, char c)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 21d:	8a 10                	mov    (%eax),%dl
 21f:	84 d2                	test   %dl,%dl
 221:	75 0c                	jne    22f <strchr+0x1b>
 223:	eb 13                	jmp    238 <strchr+0x24>
 225:	8d 76 00             	lea    0x0(%esi),%esi
 228:	40                   	inc    %eax
 229:	8a 10                	mov    (%eax),%dl
 22b:	84 d2                	test   %dl,%dl
 22d:	74 09                	je     238 <strchr+0x24>
    if(*s == c)
 22f:	38 ca                	cmp    %cl,%dl
 231:	75 f5                	jne    228 <strchr+0x14>
      return (char*)s;
  return 0;
}
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 238:	31 c0                	xor    %eax,%eax
}
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    

0000023c <gets>:

char*
gets(char *buf, int max)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	57                   	push   %edi
 240:	56                   	push   %esi
 241:	53                   	push   %ebx
 242:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 245:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 247:	8d 7d e7             	lea    -0x19(%ebp),%edi
 24a:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 24c:	8d 73 01             	lea    0x1(%ebx),%esi
 24f:	3b 75 0c             	cmp    0xc(%ebp),%esi
 252:	7d 40                	jge    294 <gets+0x58>
    cc = read(0, &c, 1);
 254:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 25b:	00 
 25c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 267:	e8 fb 00 00 00       	call   367 <read>
    if(cc < 1)
 26c:	85 c0                	test   %eax,%eax
 26e:	7e 24                	jle    294 <gets+0x58>
      break;
    buf[i++] = c;
 270:	8a 45 e7             	mov    -0x19(%ebp),%al
 273:	8b 55 08             	mov    0x8(%ebp),%edx
 276:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 27a:	3c 0a                	cmp    $0xa,%al
 27c:	74 06                	je     284 <gets+0x48>
 27e:	89 f3                	mov    %esi,%ebx
 280:	3c 0d                	cmp    $0xd,%al
 282:	75 c8                	jne    24c <gets+0x10>
      break;
  }
  buf[i] = '\0';
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 28b:	83 c4 2c             	add    $0x2c,%esp
 28e:	5b                   	pop    %ebx
 28f:	5e                   	pop    %esi
 290:	5f                   	pop    %edi
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	90                   	nop
    if(cc < 1)
 294:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 29d:	83 c4 2c             	add    $0x2c,%esp
 2a0:	5b                   	pop    %ebx
 2a1:	5e                   	pop    %esi
 2a2:	5f                   	pop    %edi
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret    
 2a5:	8d 76 00             	lea    0x0(%esi),%esi

000002a8 <stat>:

int
stat(char *n, struct stat *st)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	56                   	push   %esi
 2ac:	53                   	push   %ebx
 2ad:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b7:	00 
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	89 04 24             	mov    %eax,(%esp)
 2be:	e8 cc 00 00 00       	call   38f <open>
 2c3:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2c5:	85 c0                	test   %eax,%eax
 2c7:	78 23                	js     2ec <stat+0x44>
    return -1;
  r = fstat(fd, st);
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d0:	89 1c 24             	mov    %ebx,(%esp)
 2d3:	e8 cf 00 00 00       	call   3a7 <fstat>
 2d8:	89 c6                	mov    %eax,%esi
  close(fd);
 2da:	89 1c 24             	mov    %ebx,(%esp)
 2dd:	e8 95 00 00 00       	call   377 <close>
  return r;
}
 2e2:	89 f0                	mov    %esi,%eax
 2e4:	83 c4 10             	add    $0x10,%esp
 2e7:	5b                   	pop    %ebx
 2e8:	5e                   	pop    %esi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	90                   	nop
    return -1;
 2ec:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2f1:	eb ef                	jmp    2e2 <stat+0x3a>
 2f3:	90                   	nop

000002f4 <atoi>:

int
atoi(const char *s)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fb:	0f be 11             	movsbl (%ecx),%edx
 2fe:	8d 42 d0             	lea    -0x30(%edx),%eax
 301:	3c 09                	cmp    $0x9,%al
 303:	b8 00 00 00 00       	mov    $0x0,%eax
 308:	77 15                	ja     31f <atoi+0x2b>
 30a:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 30c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 30f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 313:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 314:	0f be 11             	movsbl (%ecx),%edx
 317:	8d 5a d0             	lea    -0x30(%edx),%ebx
 31a:	80 fb 09             	cmp    $0x9,%bl
 31d:	76 ed                	jbe    30c <atoi+0x18>
  return n;
}
 31f:	5b                   	pop    %ebx
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    
 322:	66 90                	xchg   %ax,%ax

00000324 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	56                   	push   %esi
 328:	53                   	push   %ebx
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 32f:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 332:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 334:	85 f6                	test   %esi,%esi
 336:	7e 0b                	jle    343 <memmove+0x1f>
    *dst++ = *src++;
 338:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 33b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 33e:	42                   	inc    %edx
  while(n-- > 0)
 33f:	39 f2                	cmp    %esi,%edx
 341:	75 f5                	jne    338 <memmove+0x14>
  return vdst;
}
 343:	5b                   	pop    %ebx
 344:	5e                   	pop    %esi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    

00000347 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 347:	b8 01 00 00 00       	mov    $0x1,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <exit>:
SYSCALL(exit)
 34f:	b8 02 00 00 00       	mov    $0x2,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <wait>:
SYSCALL(wait)
 357:	b8 03 00 00 00       	mov    $0x3,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <pipe>:
SYSCALL(pipe)
 35f:	b8 04 00 00 00       	mov    $0x4,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <read>:
SYSCALL(read)
 367:	b8 05 00 00 00       	mov    $0x5,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <write>:
SYSCALL(write)
 36f:	b8 10 00 00 00       	mov    $0x10,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <close>:
SYSCALL(close)
 377:	b8 15 00 00 00       	mov    $0x15,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <kill>:
SYSCALL(kill)
 37f:	b8 06 00 00 00       	mov    $0x6,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <exec>:
SYSCALL(exec)
 387:	b8 07 00 00 00       	mov    $0x7,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <open>:
SYSCALL(open)
 38f:	b8 0f 00 00 00       	mov    $0xf,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <mknod>:
SYSCALL(mknod)
 397:	b8 11 00 00 00       	mov    $0x11,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <unlink>:
SYSCALL(unlink)
 39f:	b8 12 00 00 00       	mov    $0x12,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <fstat>:
SYSCALL(fstat)
 3a7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <link>:
SYSCALL(link)
 3af:	b8 13 00 00 00       	mov    $0x13,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <mkdir>:
SYSCALL(mkdir)
 3b7:	b8 14 00 00 00       	mov    $0x14,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <chdir>:
SYSCALL(chdir)
 3bf:	b8 09 00 00 00       	mov    $0x9,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <dup>:
SYSCALL(dup)
 3c7:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <getpid>:
SYSCALL(getpid)
 3cf:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <getppid>:
SYSCALL(getppid)
 3d7:	b8 17 00 00 00       	mov    $0x17,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <sbrk>:
SYSCALL(sbrk)
 3df:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <sleep>:
SYSCALL(sleep)
 3e7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <uptime>:
SYSCALL(uptime)
 3ef:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <myfunction>:
SYSCALL(myfunction)
 3f7:	b8 16 00 00 00       	mov    $0x16,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <yield>:
SYSCALL(yield)
 3ff:	b8 18 00 00 00       	mov    $0x18,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <getlev>:
SYSCALL(getlev)
 407:	b8 19 00 00 00       	mov    $0x19,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <set_cpu_share>:
 40f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    
 417:	90                   	nop

00000418 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	57                   	push   %edi
 41c:	56                   	push   %esi
 41d:	53                   	push   %ebx
 41e:	83 ec 3c             	sub    $0x3c,%esp
 421:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 423:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 425:	8b 5d 08             	mov    0x8(%ebp),%ebx
 428:	85 db                	test   %ebx,%ebx
 42a:	74 04                	je     430 <printint+0x18>
 42c:	85 d2                	test   %edx,%edx
 42e:	78 5d                	js     48d <printint+0x75>
  neg = 0;
 430:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 432:	31 f6                	xor    %esi,%esi
 434:	eb 04                	jmp    43a <printint+0x22>
 436:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 438:	89 d6                	mov    %edx,%esi
 43a:	31 d2                	xor    %edx,%edx
 43c:	f7 f1                	div    %ecx
 43e:	8a 92 f8 07 00 00    	mov    0x7f8(%edx),%dl
 444:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 448:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 44b:	85 c0                	test   %eax,%eax
 44d:	75 e9                	jne    438 <printint+0x20>
  if(neg)
 44f:	85 db                	test   %ebx,%ebx
 451:	74 08                	je     45b <printint+0x43>
    buf[i++] = '-';
 453:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 458:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 45b:	8d 5a ff             	lea    -0x1(%edx),%ebx
 45e:	8d 75 d7             	lea    -0x29(%ebp),%esi
 461:	8d 76 00             	lea    0x0(%esi),%esi
 464:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 468:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 46b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 472:	00 
 473:	89 74 24 04          	mov    %esi,0x4(%esp)
 477:	89 3c 24             	mov    %edi,(%esp)
 47a:	e8 f0 fe ff ff       	call   36f <write>
  while(--i >= 0)
 47f:	4b                   	dec    %ebx
 480:	83 fb ff             	cmp    $0xffffffff,%ebx
 483:	75 df                	jne    464 <printint+0x4c>
    putc(fd, buf[i]);
}
 485:	83 c4 3c             	add    $0x3c,%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
    x = -xx;
 48d:	f7 d8                	neg    %eax
    neg = 1;
 48f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 494:	eb 9c                	jmp    432 <printint+0x1a>
 496:	66 90                	xchg   %ax,%ax

00000498 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 498:	55                   	push   %ebp
 499:	89 e5                	mov    %esp,%ebp
 49b:	57                   	push   %edi
 49c:	56                   	push   %esi
 49d:	53                   	push   %ebx
 49e:	83 ec 3c             	sub    $0x3c,%esp
 4a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4a7:	8a 03                	mov    (%ebx),%al
 4a9:	84 c0                	test   %al,%al
 4ab:	0f 84 bb 00 00 00    	je     56c <printf+0xd4>
printf(int fd, char *fmt, ...)
 4b1:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 4b2:	8d 55 10             	lea    0x10(%ebp),%edx
 4b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 4b8:	31 ff                	xor    %edi,%edi
 4ba:	eb 2f                	jmp    4eb <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4bc:	83 f9 25             	cmp    $0x25,%ecx
 4bf:	0f 84 af 00 00 00    	je     574 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 4c5:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	89 34 24             	mov    %esi,(%esp)
 4da:	e8 90 fe ff ff       	call   36f <write>
 4df:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 4e0:	8a 43 ff             	mov    -0x1(%ebx),%al
 4e3:	84 c0                	test   %al,%al
 4e5:	0f 84 81 00 00 00    	je     56c <printf+0xd4>
    c = fmt[i] & 0xff;
 4eb:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 4ee:	85 ff                	test   %edi,%edi
 4f0:	74 ca                	je     4bc <printf+0x24>
      }
    } else if(state == '%'){
 4f2:	83 ff 25             	cmp    $0x25,%edi
 4f5:	75 e8                	jne    4df <printf+0x47>
      if(c == 'd'){
 4f7:	83 f9 64             	cmp    $0x64,%ecx
 4fa:	0f 84 14 01 00 00    	je     614 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 500:	83 f9 78             	cmp    $0x78,%ecx
 503:	74 7b                	je     580 <printf+0xe8>
 505:	83 f9 70             	cmp    $0x70,%ecx
 508:	74 76                	je     580 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 50a:	83 f9 73             	cmp    $0x73,%ecx
 50d:	0f 84 91 00 00 00    	je     5a4 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 513:	83 f9 63             	cmp    $0x63,%ecx
 516:	0f 84 cc 00 00 00    	je     5e8 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 51c:	83 f9 25             	cmp    $0x25,%ecx
 51f:	0f 84 13 01 00 00    	je     638 <printf+0x1a0>
 525:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 529:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 530:	00 
 531:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 534:	89 44 24 04          	mov    %eax,0x4(%esp)
 538:	89 34 24             	mov    %esi,(%esp)
 53b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 53e:	e8 2c fe ff ff       	call   36f <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 543:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 546:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 549:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 550:	00 
 551:	8d 55 e7             	lea    -0x19(%ebp),%edx
 554:	89 54 24 04          	mov    %edx,0x4(%esp)
 558:	89 34 24             	mov    %esi,(%esp)
 55b:	e8 0f fe ff ff       	call   36f <write>
      }
      state = 0;
 560:	31 ff                	xor    %edi,%edi
 562:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 563:	8a 43 ff             	mov    -0x1(%ebx),%al
 566:	84 c0                	test   %al,%al
 568:	75 81                	jne    4eb <printf+0x53>
 56a:	66 90                	xchg   %ax,%ax
    }
  }
}
 56c:	83 c4 3c             	add    $0x3c,%esp
 56f:	5b                   	pop    %ebx
 570:	5e                   	pop    %esi
 571:	5f                   	pop    %edi
 572:	5d                   	pop    %ebp
 573:	c3                   	ret    
        state = '%';
 574:	bf 25 00 00 00       	mov    $0x25,%edi
 579:	e9 61 ff ff ff       	jmp    4df <printf+0x47>
 57e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 587:	b9 10 00 00 00       	mov    $0x10,%ecx
 58c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 58f:	8b 10                	mov    (%eax),%edx
 591:	89 f0                	mov    %esi,%eax
 593:	e8 80 fe ff ff       	call   418 <printint>
        ap++;
 598:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 59c:	31 ff                	xor    %edi,%edi
        ap++;
 59e:	e9 3c ff ff ff       	jmp    4df <printf+0x47>
 5a3:	90                   	nop
        s = (char*)*ap;
 5a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5a7:	8b 3a                	mov    (%edx),%edi
        ap++;
 5a9:	83 c2 04             	add    $0x4,%edx
 5ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5af:	85 ff                	test   %edi,%edi
 5b1:	0f 84 a3 00 00 00    	je     65a <printf+0x1c2>
        while(*s != 0){
 5b7:	8a 07                	mov    (%edi),%al
 5b9:	84 c0                	test   %al,%al
 5bb:	74 24                	je     5e1 <printf+0x149>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5ca:	00 
 5cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d2:	89 34 24             	mov    %esi,(%esp)
 5d5:	e8 95 fd ff ff       	call   36f <write>
          s++;
 5da:	47                   	inc    %edi
        while(*s != 0){
 5db:	8a 07                	mov    (%edi),%al
 5dd:	84 c0                	test   %al,%al
 5df:	75 df                	jne    5c0 <printf+0x128>
      state = 0;
 5e1:	31 ff                	xor    %edi,%edi
 5e3:	e9 f7 fe ff ff       	jmp    4df <printf+0x47>
        putc(fd, *ap);
 5e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5eb:	8b 02                	mov    (%edx),%eax
 5ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f7:	00 
 5f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ff:	89 34 24             	mov    %esi,(%esp)
 602:	e8 68 fd ff ff       	call   36f <write>
        ap++;
 607:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 60b:	31 ff                	xor    %edi,%edi
 60d:	e9 cd fe ff ff       	jmp    4df <printf+0x47>
 612:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 61b:	b1 0a                	mov    $0xa,%cl
 61d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 620:	8b 10                	mov    (%eax),%edx
 622:	89 f0                	mov    %esi,%eax
 624:	e8 ef fd ff ff       	call   418 <printint>
        ap++;
 629:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 62d:	66 31 ff             	xor    %di,%di
 630:	e9 aa fe ff ff       	jmp    4df <printf+0x47>
 635:	8d 76 00             	lea    0x0(%esi),%esi
 638:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 63c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 643:	00 
 644:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 647:	89 44 24 04          	mov    %eax,0x4(%esp)
 64b:	89 34 24             	mov    %esi,(%esp)
 64e:	e8 1c fd ff ff       	call   36f <write>
      state = 0;
 653:	31 ff                	xor    %edi,%edi
 655:	e9 85 fe ff ff       	jmp    4df <printf+0x47>
          s = "(null)";
 65a:	bf f1 07 00 00       	mov    $0x7f1,%edi
 65f:	e9 53 ff ff ff       	jmp    5b7 <printf+0x11f>

00000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	57                   	push   %edi
 668:	56                   	push   %esi
 669:	53                   	push   %ebx
 66a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66d:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 670:	a1 c0 0a 00 00       	mov    0xac0,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 675:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 677:	39 d0                	cmp    %edx,%eax
 679:	72 11                	jb     68c <free+0x28>
 67b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	39 c8                	cmp    %ecx,%eax
 67e:	72 04                	jb     684 <free+0x20>
 680:	39 ca                	cmp    %ecx,%edx
 682:	72 10                	jb     694 <free+0x30>
 684:	89 c8                	mov    %ecx,%eax
 686:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	39 d0                	cmp    %edx,%eax
 68a:	73 f0                	jae    67c <free+0x18>
 68c:	39 ca                	cmp    %ecx,%edx
 68e:	72 04                	jb     694 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	39 c8                	cmp    %ecx,%eax
 692:	72 f0                	jb     684 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 694:	8b 73 fc             	mov    -0x4(%ebx),%esi
 697:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 69a:	39 cf                	cmp    %ecx,%edi
 69c:	74 1a                	je     6b8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 69e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a1:	8b 48 04             	mov    0x4(%eax),%ecx
 6a4:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6a7:	39 f2                	cmp    %esi,%edx
 6a9:	74 24                	je     6cf <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ad:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 6b2:	5b                   	pop    %ebx
 6b3:	5e                   	pop    %esi
 6b4:	5f                   	pop    %edi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    
 6b7:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6b8:	03 71 04             	add    0x4(%ecx),%esi
 6bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	8b 08                	mov    (%eax),%ecx
 6c0:	8b 09                	mov    (%ecx),%ecx
 6c2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6c5:	8b 48 04             	mov    0x4(%eax),%ecx
 6c8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6cb:	39 f2                	cmp    %esi,%edx
 6cd:	75 dc                	jne    6ab <free+0x47>
    p->s.size += bp->s.size;
 6cf:	03 4b fc             	add    -0x4(%ebx),%ecx
 6d2:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6d8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6da:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 6df:	5b                   	pop    %ebx
 6e0:	5e                   	pop    %esi
 6e1:	5f                   	pop    %edi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    

000006e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	57                   	push   %edi
 6e8:	56                   	push   %esi
 6e9:	53                   	push   %ebx
 6ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ed:	8b 75 08             	mov    0x8(%ebp),%esi
 6f0:	83 c6 07             	add    $0x7,%esi
 6f3:	c1 ee 03             	shr    $0x3,%esi
 6f6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6f7:	8b 15 c0 0a 00 00    	mov    0xac0,%edx
 6fd:	85 d2                	test   %edx,%edx
 6ff:	0f 84 8d 00 00 00    	je     792 <malloc+0xae>
 705:	8b 02                	mov    (%edx),%eax
 707:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 70a:	39 ce                	cmp    %ecx,%esi
 70c:	76 52                	jbe    760 <malloc+0x7c>
 70e:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 715:	eb 0a                	jmp    721 <malloc+0x3d>
 717:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 718:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 ce                	cmp    %ecx,%esi
 71f:	76 3f                	jbe    760 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	89 c2                	mov    %eax,%edx
 723:	3b 05 c0 0a 00 00    	cmp    0xac0,%eax
 729:	75 ed                	jne    718 <malloc+0x34>
  if(nu < 4096)
 72b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 731:	76 4d                	jbe    780 <malloc+0x9c>
 733:	89 d8                	mov    %ebx,%eax
 735:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 a0 fc ff ff       	call   3df <sbrk>
  if(p == (char*)-1)
 73f:	83 f8 ff             	cmp    $0xffffffff,%eax
 742:	74 18                	je     75c <malloc+0x78>
  hp->s.size = nu;
 744:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 747:	83 c0 08             	add    $0x8,%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 12 ff ff ff       	call   664 <free>
  return freep;
 752:	8b 15 c0 0a 00 00    	mov    0xac0,%edx
      if((p = morecore(nunits)) == 0)
 758:	85 d2                	test   %edx,%edx
 75a:	75 bc                	jne    718 <malloc+0x34>
        return 0;
 75c:	31 c0                	xor    %eax,%eax
 75e:	eb 18                	jmp    778 <malloc+0x94>
      if(p->s.size == nunits)
 760:	39 ce                	cmp    %ecx,%esi
 762:	74 28                	je     78c <malloc+0xa8>
        p->s.size -= nunits;
 764:	29 f1                	sub    %esi,%ecx
 766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 76c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 76f:	89 15 c0 0a 00 00    	mov    %edx,0xac0
      return (void*)(p + 1);
 775:	83 c0 08             	add    $0x8,%eax
  }
}
 778:	83 c4 1c             	add    $0x1c,%esp
 77b:	5b                   	pop    %ebx
 77c:	5e                   	pop    %esi
 77d:	5f                   	pop    %edi
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret    
  if(nu < 4096)
 780:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 785:	bf 00 10 00 00       	mov    $0x1000,%edi
 78a:	eb ab                	jmp    737 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 78c:	8b 08                	mov    (%eax),%ecx
 78e:	89 0a                	mov    %ecx,(%edx)
 790:	eb dd                	jmp    76f <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 792:	c7 05 c0 0a 00 00 c4 	movl   $0xac4,0xac0
 799:	0a 00 00 
 79c:	c7 05 c4 0a 00 00 c4 	movl   $0xac4,0xac4
 7a3:	0a 00 00 
    base.s.size = 0;
 7a6:	c7 05 c8 0a 00 00 00 	movl   $0x0,0xac8
 7ad:	00 00 00 
 7b0:	b8 c4 0a 00 00       	mov    $0xac4,%eax
 7b5:	e9 54 ff ff ff       	jmp    70e <malloc+0x2a>
