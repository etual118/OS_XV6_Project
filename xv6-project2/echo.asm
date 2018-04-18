
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  for(i = 1; i < argc; i++)
  12:	83 fe 01             	cmp    $0x1,%esi
  15:	7e 5a                	jle    71 <main+0x71>
  17:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1c:	43                   	inc    %ebx
  1d:	39 f3                	cmp    %esi,%ebx
  1f:	74 2c                	je     4d <main+0x4d>
  21:	8d 76 00             	lea    0x0(%esi),%esi
  24:	c7 44 24 0c ae 06 00 	movl   $0x6ae,0xc(%esp)
  2b:	00 
  2c:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  30:	89 44 24 08          	mov    %eax,0x8(%esp)
  34:	c7 44 24 04 b0 06 00 	movl   $0x6b0,0x4(%esp)
  3b:	00 
  3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  43:	e8 44 03 00 00       	call   38c <printf>
  48:	43                   	inc    %ebx
  49:	39 f3                	cmp    %esi,%ebx
  4b:	75 d7                	jne    24 <main+0x24>
  4d:	c7 44 24 0c b5 06 00 	movl   $0x6b5,0xc(%esp)
  54:	00 
  55:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  59:	89 44 24 08          	mov    %eax,0x8(%esp)
  5d:	c7 44 24 04 b0 06 00 	movl   $0x6b0,0x4(%esp)
  64:	00 
  65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6c:	e8 1b 03 00 00       	call   38c <printf>
  exit();
  71:	e8 cd 01 00 00       	call   243 <exit>
  76:	66 90                	xchg   %ax,%ax

00000078 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	89 c2                	mov    %eax,%edx
  84:	8a 19                	mov    (%ecx),%bl
  86:	88 1a                	mov    %bl,(%edx)
  88:	42                   	inc    %edx
  89:	41                   	inc    %ecx
  8a:	84 db                	test   %bl,%bl
  8c:	75 f6                	jne    84 <strcpy+0xc>
    ;
  return os;
}
  8e:	5b                   	pop    %ebx
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    
  91:	8d 76 00             	lea    0x0(%esi),%esi

00000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  99:	8b 55 08             	mov    0x8(%ebp),%edx
  9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9f:	0f b6 02             	movzbl (%edx),%eax
  a2:	0f b6 19             	movzbl (%ecx),%ebx
  a5:	84 c0                	test   %al,%al
  a7:	75 14                	jne    bd <strcmp+0x29>
  a9:	eb 1d                	jmp    c8 <strcmp+0x34>
  ab:	90                   	nop
    p++, q++;
  ac:	42                   	inc    %edx
  ad:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  b0:	0f b6 02             	movzbl (%edx),%eax
  b3:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  b7:	84 c0                	test   %al,%al
  b9:	74 0d                	je     c8 <strcmp+0x34>
    p++, q++;
  bb:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  bd:	38 d8                	cmp    %bl,%al
  bf:	74 eb                	je     ac <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  c1:	29 d8                	sub    %ebx,%eax
}
  c3:	5b                   	pop    %ebx
  c4:	5e                   	pop    %esi
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop
  while(*p && *p == *q)
  c8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  ca:	29 d8                	sub    %ebx,%eax
}
  cc:	5b                   	pop    %ebx
  cd:	5e                   	pop    %esi
  ce:	5d                   	pop    %ebp
  cf:	c3                   	ret    

000000d0 <strlen>:

uint
strlen(char *s)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d6:	80 39 00             	cmpb   $0x0,(%ecx)
  d9:	74 10                	je     eb <strlen+0x1b>
  db:	31 d2                	xor    %edx,%edx
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	42                   	inc    %edx
  e1:	89 d0                	mov    %edx,%eax
  e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  e7:	75 f7                	jne    e0 <strlen+0x10>
    ;
  return n;
}
  e9:	5d                   	pop    %ebp
  ea:	c3                   	ret    
  for(n = 0; s[n]; n++)
  eb:	31 c0                	xor    %eax,%eax
}
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    
  ef:	90                   	nop

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	89 d7                	mov    %edx,%edi
  f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	fc                   	cld    
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	89 d0                	mov    %edx,%eax
 104:	5f                   	pop    %edi
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	90                   	nop

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	75 0c                	jne    123 <strchr+0x1b>
 117:	eb 13                	jmp    12c <strchr+0x24>
 119:	8d 76 00             	lea    0x0(%esi),%esi
 11c:	40                   	inc    %eax
 11d:	8a 10                	mov    (%eax),%dl
 11f:	84 d2                	test   %dl,%dl
 121:	74 09                	je     12c <strchr+0x24>
    if(*s == c)
 123:	38 ca                	cmp    %cl,%dl
 125:	75 f5                	jne    11c <strchr+0x14>
      return (char*)s;
  return 0;
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret    
 129:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 12c:	31 c0                	xor    %eax,%eax
}
 12e:	5d                   	pop    %ebp
 12f:	c3                   	ret    

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
 135:	53                   	push   %ebx
 136:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 139:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 13b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 13e:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 140:	8d 73 01             	lea    0x1(%ebx),%esi
 143:	3b 75 0c             	cmp    0xc(%ebp),%esi
 146:	7d 40                	jge    188 <gets+0x58>
    cc = read(0, &c, 1);
 148:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14f:	00 
 150:	89 7c 24 04          	mov    %edi,0x4(%esp)
 154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15b:	e8 fb 00 00 00       	call   25b <read>
    if(cc < 1)
 160:	85 c0                	test   %eax,%eax
 162:	7e 24                	jle    188 <gets+0x58>
      break;
    buf[i++] = c;
 164:	8a 45 e7             	mov    -0x19(%ebp),%al
 167:	8b 55 08             	mov    0x8(%ebp),%edx
 16a:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 16e:	3c 0a                	cmp    $0xa,%al
 170:	74 06                	je     178 <gets+0x48>
 172:	89 f3                	mov    %esi,%ebx
 174:	3c 0d                	cmp    $0xd,%al
 176:	75 c8                	jne    140 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 17f:	83 c4 2c             	add    $0x2c,%esp
 182:	5b                   	pop    %ebx
 183:	5e                   	pop    %esi
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	90                   	nop
    if(cc < 1)
 188:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 191:	83 c4 2c             	add    $0x2c,%esp
 194:	5b                   	pop    %ebx
 195:	5e                   	pop    %esi
 196:	5f                   	pop    %edi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d 76 00             	lea    0x0(%esi),%esi

0000019c <stat>:

int
stat(char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	56                   	push   %esi
 1a0:	53                   	push   %ebx
 1a1:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ab:	00 
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	89 04 24             	mov    %eax,(%esp)
 1b2:	e8 cc 00 00 00       	call   283 <open>
 1b7:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1b9:	85 c0                	test   %eax,%eax
 1bb:	78 23                	js     1e0 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	89 1c 24             	mov    %ebx,(%esp)
 1c7:	e8 cf 00 00 00       	call   29b <fstat>
 1cc:	89 c6                	mov    %eax,%esi
  close(fd);
 1ce:	89 1c 24             	mov    %ebx,(%esp)
 1d1:	e8 95 00 00 00       	call   26b <close>
  return r;
}
 1d6:	89 f0                	mov    %esi,%eax
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    
 1df:	90                   	nop
    return -1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e5:	eb ef                	jmp    1d6 <stat+0x3a>
 1e7:	90                   	nop

000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	53                   	push   %ebx
 1ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ef:	0f be 11             	movsbl (%ecx),%edx
 1f2:	8d 42 d0             	lea    -0x30(%edx),%eax
 1f5:	3c 09                	cmp    $0x9,%al
 1f7:	b8 00 00 00 00       	mov    $0x0,%eax
 1fc:	77 15                	ja     213 <atoi+0x2b>
 1fe:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 200:	8d 04 80             	lea    (%eax,%eax,4),%eax
 203:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 207:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 208:	0f be 11             	movsbl (%ecx),%edx
 20b:	8d 5a d0             	lea    -0x30(%edx),%ebx
 20e:	80 fb 09             	cmp    $0x9,%bl
 211:	76 ed                	jbe    200 <atoi+0x18>
  return n;
}
 213:	5b                   	pop    %ebx
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    
 216:	66 90                	xchg   %ax,%ax

00000218 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	56                   	push   %esi
 21c:	53                   	push   %ebx
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 223:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 226:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 228:	85 f6                	test   %esi,%esi
 22a:	7e 0b                	jle    237 <memmove+0x1f>
    *dst++ = *src++;
 22c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 22f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 232:	42                   	inc    %edx
  while(n-- > 0)
 233:	39 f2                	cmp    %esi,%edx
 235:	75 f5                	jne    22c <memmove+0x14>
  return vdst;
}
 237:	5b                   	pop    %ebx
 238:	5e                   	pop    %esi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23b:	b8 01 00 00 00       	mov    $0x1,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <exit>:
SYSCALL(exit)
 243:	b8 02 00 00 00       	mov    $0x2,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <wait>:
SYSCALL(wait)
 24b:	b8 03 00 00 00       	mov    $0x3,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <pipe>:
SYSCALL(pipe)
 253:	b8 04 00 00 00       	mov    $0x4,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <read>:
SYSCALL(read)
 25b:	b8 05 00 00 00       	mov    $0x5,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <write>:
SYSCALL(write)
 263:	b8 10 00 00 00       	mov    $0x10,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <close>:
SYSCALL(close)
 26b:	b8 15 00 00 00       	mov    $0x15,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <kill>:
SYSCALL(kill)
 273:	b8 06 00 00 00       	mov    $0x6,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <exec>:
SYSCALL(exec)
 27b:	b8 07 00 00 00       	mov    $0x7,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <open>:
SYSCALL(open)
 283:	b8 0f 00 00 00       	mov    $0xf,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <mknod>:
SYSCALL(mknod)
 28b:	b8 11 00 00 00       	mov    $0x11,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <unlink>:
SYSCALL(unlink)
 293:	b8 12 00 00 00       	mov    $0x12,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <fstat>:
SYSCALL(fstat)
 29b:	b8 08 00 00 00       	mov    $0x8,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <link>:
SYSCALL(link)
 2a3:	b8 13 00 00 00       	mov    $0x13,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <mkdir>:
SYSCALL(mkdir)
 2ab:	b8 14 00 00 00       	mov    $0x14,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <chdir>:
SYSCALL(chdir)
 2b3:	b8 09 00 00 00       	mov    $0x9,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <dup>:
SYSCALL(dup)
 2bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <getpid>:
SYSCALL(getpid)
 2c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <getppid>:
SYSCALL(getppid)
 2cb:	b8 17 00 00 00       	mov    $0x17,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <sbrk>:
SYSCALL(sbrk)
 2d3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <sleep>:
SYSCALL(sleep)
 2db:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <uptime>:
SYSCALL(uptime)
 2e3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <myfunction>:
SYSCALL(myfunction)
 2eb:	b8 16 00 00 00       	mov    $0x16,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <yield>:
SYSCALL(yield)
 2f3:	b8 18 00 00 00       	mov    $0x18,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <getlev>:
SYSCALL(getlev)
 2fb:	b8 19 00 00 00       	mov    $0x19,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <set_cpu_share>:
 303:	b8 1a 00 00 00       	mov    $0x1a,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    
 30b:	90                   	nop

0000030c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	57                   	push   %edi
 310:	56                   	push   %esi
 311:	53                   	push   %ebx
 312:	83 ec 3c             	sub    $0x3c,%esp
 315:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 317:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 319:	8b 5d 08             	mov    0x8(%ebp),%ebx
 31c:	85 db                	test   %ebx,%ebx
 31e:	74 04                	je     324 <printint+0x18>
 320:	85 d2                	test   %edx,%edx
 322:	78 5d                	js     381 <printint+0x75>
  neg = 0;
 324:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 326:	31 f6                	xor    %esi,%esi
 328:	eb 04                	jmp    32e <printint+0x22>
 32a:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 32c:	89 d6                	mov    %edx,%esi
 32e:	31 d2                	xor    %edx,%edx
 330:	f7 f1                	div    %ecx
 332:	8a 92 be 06 00 00    	mov    0x6be(%edx),%dl
 338:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 33c:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 33f:	85 c0                	test   %eax,%eax
 341:	75 e9                	jne    32c <printint+0x20>
  if(neg)
 343:	85 db                	test   %ebx,%ebx
 345:	74 08                	je     34f <printint+0x43>
    buf[i++] = '-';
 347:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 34c:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 34f:	8d 5a ff             	lea    -0x1(%edx),%ebx
 352:	8d 75 d7             	lea    -0x29(%ebp),%esi
 355:	8d 76 00             	lea    0x0(%esi),%esi
 358:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 35c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 35f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 366:	00 
 367:	89 74 24 04          	mov    %esi,0x4(%esp)
 36b:	89 3c 24             	mov    %edi,(%esp)
 36e:	e8 f0 fe ff ff       	call   263 <write>
  while(--i >= 0)
 373:	4b                   	dec    %ebx
 374:	83 fb ff             	cmp    $0xffffffff,%ebx
 377:	75 df                	jne    358 <printint+0x4c>
    putc(fd, buf[i]);
}
 379:	83 c4 3c             	add    $0x3c,%esp
 37c:	5b                   	pop    %ebx
 37d:	5e                   	pop    %esi
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
    x = -xx;
 381:	f7 d8                	neg    %eax
    neg = 1;
 383:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 388:	eb 9c                	jmp    326 <printint+0x1a>
 38a:	66 90                	xchg   %ax,%ax

0000038c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	57                   	push   %edi
 390:	56                   	push   %esi
 391:	53                   	push   %ebx
 392:	83 ec 3c             	sub    $0x3c,%esp
 395:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 39b:	8a 03                	mov    (%ebx),%al
 39d:	84 c0                	test   %al,%al
 39f:	0f 84 bb 00 00 00    	je     460 <printf+0xd4>
printf(int fd, char *fmt, ...)
 3a5:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3a6:	8d 55 10             	lea    0x10(%ebp),%edx
 3a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 3ac:	31 ff                	xor    %edi,%edi
 3ae:	eb 2f                	jmp    3df <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3b0:	83 f9 25             	cmp    $0x25,%ecx
 3b3:	0f 84 af 00 00 00    	je     468 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 3b9:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 3bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c3:	00 
 3c4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cb:	89 34 24             	mov    %esi,(%esp)
 3ce:	e8 90 fe ff ff       	call   263 <write>
 3d3:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3d4:	8a 43 ff             	mov    -0x1(%ebx),%al
 3d7:	84 c0                	test   %al,%al
 3d9:	0f 84 81 00 00 00    	je     460 <printf+0xd4>
    c = fmt[i] & 0xff;
 3df:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3e2:	85 ff                	test   %edi,%edi
 3e4:	74 ca                	je     3b0 <printf+0x24>
      }
    } else if(state == '%'){
 3e6:	83 ff 25             	cmp    $0x25,%edi
 3e9:	75 e8                	jne    3d3 <printf+0x47>
      if(c == 'd'){
 3eb:	83 f9 64             	cmp    $0x64,%ecx
 3ee:	0f 84 14 01 00 00    	je     508 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3f4:	83 f9 78             	cmp    $0x78,%ecx
 3f7:	74 7b                	je     474 <printf+0xe8>
 3f9:	83 f9 70             	cmp    $0x70,%ecx
 3fc:	74 76                	je     474 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3fe:	83 f9 73             	cmp    $0x73,%ecx
 401:	0f 84 91 00 00 00    	je     498 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 407:	83 f9 63             	cmp    $0x63,%ecx
 40a:	0f 84 cc 00 00 00    	je     4dc <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 410:	83 f9 25             	cmp    $0x25,%ecx
 413:	0f 84 13 01 00 00    	je     52c <printf+0x1a0>
 419:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 41d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 424:	00 
 425:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 428:	89 44 24 04          	mov    %eax,0x4(%esp)
 42c:	89 34 24             	mov    %esi,(%esp)
 42f:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 432:	e8 2c fe ff ff       	call   263 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 437:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 43a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 43d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 444:	00 
 445:	8d 55 e7             	lea    -0x19(%ebp),%edx
 448:	89 54 24 04          	mov    %edx,0x4(%esp)
 44c:	89 34 24             	mov    %esi,(%esp)
 44f:	e8 0f fe ff ff       	call   263 <write>
      }
      state = 0;
 454:	31 ff                	xor    %edi,%edi
 456:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 457:	8a 43 ff             	mov    -0x1(%ebx),%al
 45a:	84 c0                	test   %al,%al
 45c:	75 81                	jne    3df <printf+0x53>
 45e:	66 90                	xchg   %ax,%ax
    }
  }
}
 460:	83 c4 3c             	add    $0x3c,%esp
 463:	5b                   	pop    %ebx
 464:	5e                   	pop    %esi
 465:	5f                   	pop    %edi
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
        state = '%';
 468:	bf 25 00 00 00       	mov    $0x25,%edi
 46d:	e9 61 ff ff ff       	jmp    3d3 <printf+0x47>
 472:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 47b:	b9 10 00 00 00       	mov    $0x10,%ecx
 480:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 483:	8b 10                	mov    (%eax),%edx
 485:	89 f0                	mov    %esi,%eax
 487:	e8 80 fe ff ff       	call   30c <printint>
        ap++;
 48c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 490:	31 ff                	xor    %edi,%edi
        ap++;
 492:	e9 3c ff ff ff       	jmp    3d3 <printf+0x47>
 497:	90                   	nop
        s = (char*)*ap;
 498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 49b:	8b 3a                	mov    (%edx),%edi
        ap++;
 49d:	83 c2 04             	add    $0x4,%edx
 4a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 4a3:	85 ff                	test   %edi,%edi
 4a5:	0f 84 a3 00 00 00    	je     54e <printf+0x1c2>
        while(*s != 0){
 4ab:	8a 07                	mov    (%edi),%al
 4ad:	84 c0                	test   %al,%al
 4af:	74 24                	je     4d5 <printf+0x149>
 4b1:	8d 76 00             	lea    0x0(%esi),%esi
 4b4:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4be:	00 
 4bf:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	89 34 24             	mov    %esi,(%esp)
 4c9:	e8 95 fd ff ff       	call   263 <write>
          s++;
 4ce:	47                   	inc    %edi
        while(*s != 0){
 4cf:	8a 07                	mov    (%edi),%al
 4d1:	84 c0                	test   %al,%al
 4d3:	75 df                	jne    4b4 <printf+0x128>
      state = 0;
 4d5:	31 ff                	xor    %edi,%edi
 4d7:	e9 f7 fe ff ff       	jmp    3d3 <printf+0x47>
        putc(fd, *ap);
 4dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4df:	8b 02                	mov    (%edx),%eax
 4e1:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4eb:	00 
 4ec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f3:	89 34 24             	mov    %esi,(%esp)
 4f6:	e8 68 fd ff ff       	call   263 <write>
        ap++;
 4fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4ff:	31 ff                	xor    %edi,%edi
 501:	e9 cd fe ff ff       	jmp    3d3 <printf+0x47>
 506:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 508:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 50f:	b1 0a                	mov    $0xa,%cl
 511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 514:	8b 10                	mov    (%eax),%edx
 516:	89 f0                	mov    %esi,%eax
 518:	e8 ef fd ff ff       	call   30c <printint>
        ap++;
 51d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 521:	66 31 ff             	xor    %di,%di
 524:	e9 aa fe ff ff       	jmp    3d3 <printf+0x47>
 529:	8d 76 00             	lea    0x0(%esi),%esi
 52c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 530:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 537:	00 
 538:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 53b:	89 44 24 04          	mov    %eax,0x4(%esp)
 53f:	89 34 24             	mov    %esi,(%esp)
 542:	e8 1c fd ff ff       	call   263 <write>
      state = 0;
 547:	31 ff                	xor    %edi,%edi
 549:	e9 85 fe ff ff       	jmp    3d3 <printf+0x47>
          s = "(null)";
 54e:	bf b7 06 00 00       	mov    $0x6b7,%edi
 553:	e9 53 ff ff ff       	jmp    4ab <printf+0x11f>

00000558 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 561:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 564:	a1 54 09 00 00       	mov    0x954,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 569:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56b:	39 d0                	cmp    %edx,%eax
 56d:	72 11                	jb     580 <free+0x28>
 56f:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 570:	39 c8                	cmp    %ecx,%eax
 572:	72 04                	jb     578 <free+0x20>
 574:	39 ca                	cmp    %ecx,%edx
 576:	72 10                	jb     588 <free+0x30>
 578:	89 c8                	mov    %ecx,%eax
 57a:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57c:	39 d0                	cmp    %edx,%eax
 57e:	73 f0                	jae    570 <free+0x18>
 580:	39 ca                	cmp    %ecx,%edx
 582:	72 04                	jb     588 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 584:	39 c8                	cmp    %ecx,%eax
 586:	72 f0                	jb     578 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 588:	8b 73 fc             	mov    -0x4(%ebx),%esi
 58b:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 58e:	39 cf                	cmp    %ecx,%edi
 590:	74 1a                	je     5ac <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 592:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 595:	8b 48 04             	mov    0x4(%eax),%ecx
 598:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 59b:	39 f2                	cmp    %esi,%edx
 59d:	74 24                	je     5c3 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 59f:	89 10                	mov    %edx,(%eax)
  freep = p;
 5a1:	a3 54 09 00 00       	mov    %eax,0x954
}
 5a6:	5b                   	pop    %ebx
 5a7:	5e                   	pop    %esi
 5a8:	5f                   	pop    %edi
 5a9:	5d                   	pop    %ebp
 5aa:	c3                   	ret    
 5ab:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5ac:	03 71 04             	add    0x4(%ecx),%esi
 5af:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b2:	8b 08                	mov    (%eax),%ecx
 5b4:	8b 09                	mov    (%ecx),%ecx
 5b6:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b9:	8b 48 04             	mov    0x4(%eax),%ecx
 5bc:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5bf:	39 f2                	cmp    %esi,%edx
 5c1:	75 dc                	jne    59f <free+0x47>
    p->s.size += bp->s.size;
 5c3:	03 4b fc             	add    -0x4(%ebx),%ecx
 5c6:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5c9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5cc:	89 10                	mov    %edx,(%eax)
  freep = p;
 5ce:	a3 54 09 00 00       	mov    %eax,0x954
}
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    

000005d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	57                   	push   %edi
 5dc:	56                   	push   %esi
 5dd:	53                   	push   %ebx
 5de:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e1:	8b 75 08             	mov    0x8(%ebp),%esi
 5e4:	83 c6 07             	add    $0x7,%esi
 5e7:	c1 ee 03             	shr    $0x3,%esi
 5ea:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5eb:	8b 15 54 09 00 00    	mov    0x954,%edx
 5f1:	85 d2                	test   %edx,%edx
 5f3:	0f 84 8d 00 00 00    	je     686 <malloc+0xae>
 5f9:	8b 02                	mov    (%edx),%eax
 5fb:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5fe:	39 ce                	cmp    %ecx,%esi
 600:	76 52                	jbe    654 <malloc+0x7c>
 602:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 609:	eb 0a                	jmp    615 <malloc+0x3d>
 60b:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 60e:	8b 48 04             	mov    0x4(%eax),%ecx
 611:	39 ce                	cmp    %ecx,%esi
 613:	76 3f                	jbe    654 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 615:	89 c2                	mov    %eax,%edx
 617:	3b 05 54 09 00 00    	cmp    0x954,%eax
 61d:	75 ed                	jne    60c <malloc+0x34>
  if(nu < 4096)
 61f:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 625:	76 4d                	jbe    674 <malloc+0x9c>
 627:	89 d8                	mov    %ebx,%eax
 629:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 a0 fc ff ff       	call   2d3 <sbrk>
  if(p == (char*)-1)
 633:	83 f8 ff             	cmp    $0xffffffff,%eax
 636:	74 18                	je     650 <malloc+0x78>
  hp->s.size = nu;
 638:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 63b:	83 c0 08             	add    $0x8,%eax
 63e:	89 04 24             	mov    %eax,(%esp)
 641:	e8 12 ff ff ff       	call   558 <free>
  return freep;
 646:	8b 15 54 09 00 00    	mov    0x954,%edx
      if((p = morecore(nunits)) == 0)
 64c:	85 d2                	test   %edx,%edx
 64e:	75 bc                	jne    60c <malloc+0x34>
        return 0;
 650:	31 c0                	xor    %eax,%eax
 652:	eb 18                	jmp    66c <malloc+0x94>
      if(p->s.size == nunits)
 654:	39 ce                	cmp    %ecx,%esi
 656:	74 28                	je     680 <malloc+0xa8>
        p->s.size -= nunits;
 658:	29 f1                	sub    %esi,%ecx
 65a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 65d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 660:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 663:	89 15 54 09 00 00    	mov    %edx,0x954
      return (void*)(p + 1);
 669:	83 c0 08             	add    $0x8,%eax
  }
}
 66c:	83 c4 1c             	add    $0x1c,%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
  if(nu < 4096)
 674:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 679:	bf 00 10 00 00       	mov    $0x1000,%edi
 67e:	eb ab                	jmp    62b <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 680:	8b 08                	mov    (%eax),%ecx
 682:	89 0a                	mov    %ecx,(%edx)
 684:	eb dd                	jmp    663 <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 686:	c7 05 54 09 00 00 58 	movl   $0x958,0x954
 68d:	09 00 00 
 690:	c7 05 58 09 00 00 58 	movl   $0x958,0x958
 697:	09 00 00 
    base.s.size = 0;
 69a:	c7 05 5c 09 00 00 00 	movl   $0x0,0x95c
 6a1:	00 00 00 
 6a4:	b8 58 09 00 00       	mov    $0x958,%eax
 6a9:	e9 54 ff ff ff       	jmp    602 <malloc+0x2a>
