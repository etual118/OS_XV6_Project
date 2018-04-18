
_mkdir:     file format elf32-i386


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
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  if(argc < 2){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 43                	jle    57 <main+0x57>
main(int argc, char *argv[])
  14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  17:	83 c3 04             	add    $0x4,%ebx
  1a:	be 01 00 00 00       	mov    $0x1,%esi
  1f:	90                   	nop
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  20:	8b 03                	mov    (%ebx),%eax
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 79 02 00 00       	call   2a3 <mkdir>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 0d                	js     3b <main+0x3b>
  for(i = 1; i < argc; i++){
  2e:	46                   	inc    %esi
  2f:	83 c3 04             	add    $0x4,%ebx
  32:	39 fe                	cmp    %edi,%esi
  34:	75 ea                	jne    20 <main+0x20>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  36:	e8 00 02 00 00       	call   23b <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  3b:	8b 03                	mov    (%ebx),%eax
  3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  41:	c7 44 24 04 bd 06 00 	movl   $0x6bd,0x4(%esp)
  48:	00 
  49:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  50:	e8 2f 03 00 00       	call   384 <printf>
      break;
  55:	eb df                	jmp    36 <main+0x36>
    printf(2, "Usage: mkdir files...\n");
  57:	c7 44 24 04 a6 06 00 	movl   $0x6a6,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  66:	e8 19 03 00 00       	call   384 <printf>
    exit();
  6b:	e8 cb 01 00 00       	call   23b <exit>

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	89 c2                	mov    %eax,%edx
  7c:	8a 19                	mov    (%ecx),%bl
  7e:	88 1a                	mov    %bl,(%edx)
  80:	42                   	inc    %edx
  81:	41                   	inc    %ecx
  82:	84 db                	test   %bl,%bl
  84:	75 f6                	jne    7c <strcpy+0xc>
    ;
  return os;
}
  86:	5b                   	pop    %ebx
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    
  89:	8d 76 00             	lea    0x0(%esi),%esi

0000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	56                   	push   %esi
  90:	53                   	push   %ebx
  91:	8b 55 08             	mov    0x8(%ebp),%edx
  94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  97:	0f b6 02             	movzbl (%edx),%eax
  9a:	0f b6 19             	movzbl (%ecx),%ebx
  9d:	84 c0                	test   %al,%al
  9f:	75 14                	jne    b5 <strcmp+0x29>
  a1:	eb 1d                	jmp    c0 <strcmp+0x34>
  a3:	90                   	nop
    p++, q++;
  a4:	42                   	inc    %edx
  a5:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  a8:	0f b6 02             	movzbl (%edx),%eax
  ab:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  af:	84 c0                	test   %al,%al
  b1:	74 0d                	je     c0 <strcmp+0x34>
    p++, q++;
  b3:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  b5:	38 d8                	cmp    %bl,%al
  b7:	74 eb                	je     a4 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b9:	29 d8                	sub    %ebx,%eax
}
  bb:	5b                   	pop    %ebx
  bc:	5e                   	pop    %esi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
  bf:	90                   	nop
  while(*p && *p == *q)
  c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  c2:	29 d8                	sub    %ebx,%eax
}
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strlen>:

uint
strlen(char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ce:	80 39 00             	cmpb   $0x0,(%ecx)
  d1:	74 10                	je     e3 <strlen+0x1b>
  d3:	31 d2                	xor    %edx,%edx
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  d8:	42                   	inc    %edx
  d9:	89 d0                	mov    %edx,%eax
  db:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  df:	75 f7                	jne    d8 <strlen+0x10>
    ;
  return n;
}
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e3:	31 c0                	xor    %eax,%eax
}
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
  ec:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ef:	89 d7                	mov    %edx,%edi
  f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	fc                   	cld    
  f8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fa:	89 d0                	mov    %edx,%eax
  fc:	5f                   	pop    %edi
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    
  ff:	90                   	nop

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 109:	8a 10                	mov    (%eax),%dl
 10b:	84 d2                	test   %dl,%dl
 10d:	75 0c                	jne    11b <strchr+0x1b>
 10f:	eb 13                	jmp    124 <strchr+0x24>
 111:	8d 76 00             	lea    0x0(%esi),%esi
 114:	40                   	inc    %eax
 115:	8a 10                	mov    (%eax),%dl
 117:	84 d2                	test   %dl,%dl
 119:	74 09                	je     124 <strchr+0x24>
    if(*s == c)
 11b:	38 ca                	cmp    %cl,%dl
 11d:	75 f5                	jne    114 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 124:	31 c0                	xor    %eax,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	57                   	push   %edi
 12c:	56                   	push   %esi
 12d:	53                   	push   %ebx
 12e:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 131:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 133:	8d 7d e7             	lea    -0x19(%ebp),%edi
 136:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 138:	8d 73 01             	lea    0x1(%ebx),%esi
 13b:	3b 75 0c             	cmp    0xc(%ebp),%esi
 13e:	7d 40                	jge    180 <gets+0x58>
    cc = read(0, &c, 1);
 140:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 147:	00 
 148:	89 7c 24 04          	mov    %edi,0x4(%esp)
 14c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 153:	e8 fb 00 00 00       	call   253 <read>
    if(cc < 1)
 158:	85 c0                	test   %eax,%eax
 15a:	7e 24                	jle    180 <gets+0x58>
      break;
    buf[i++] = c;
 15c:	8a 45 e7             	mov    -0x19(%ebp),%al
 15f:	8b 55 08             	mov    0x8(%ebp),%edx
 162:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 166:	3c 0a                	cmp    $0xa,%al
 168:	74 06                	je     170 <gets+0x48>
 16a:	89 f3                	mov    %esi,%ebx
 16c:	3c 0d                	cmp    $0xd,%al
 16e:	75 c8                	jne    138 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 177:	83 c4 2c             	add    $0x2c,%esp
 17a:	5b                   	pop    %ebx
 17b:	5e                   	pop    %esi
 17c:	5f                   	pop    %edi
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
 17f:	90                   	nop
    if(cc < 1)
 180:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 189:	83 c4 2c             	add    $0x2c,%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5f                   	pop    %edi
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi

00000194 <stat>:

int
stat(char *n, struct stat *st)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	56                   	push   %esi
 198:	53                   	push   %ebx
 199:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a3:	00 
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	89 04 24             	mov    %eax,(%esp)
 1aa:	e8 cc 00 00 00       	call   27b <open>
 1af:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1b1:	85 c0                	test   %eax,%eax
 1b3:	78 23                	js     1d8 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 1b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bc:	89 1c 24             	mov    %ebx,(%esp)
 1bf:	e8 cf 00 00 00       	call   293 <fstat>
 1c4:	89 c6                	mov    %eax,%esi
  close(fd);
 1c6:	89 1c 24             	mov    %ebx,(%esp)
 1c9:	e8 95 00 00 00       	call   263 <close>
  return r;
}
 1ce:	89 f0                	mov    %esi,%eax
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	90                   	nop
    return -1;
 1d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1dd:	eb ef                	jmp    1ce <stat+0x3a>
 1df:	90                   	nop

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	0f be 11             	movsbl (%ecx),%edx
 1ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 1ed:	3c 09                	cmp    $0x9,%al
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
 1f4:	77 15                	ja     20b <atoi+0x2b>
 1f6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1fb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1ff:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 200:	0f be 11             	movsbl (%ecx),%edx
 203:	8d 5a d0             	lea    -0x30(%edx),%ebx
 206:	80 fb 09             	cmp    $0x9,%bl
 209:	76 ed                	jbe    1f8 <atoi+0x18>
  return n;
}
 20b:	5b                   	pop    %ebx
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
 20e:	66 90                	xchg   %ax,%ax

00000210 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 21b:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 21e:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 220:	85 f6                	test   %esi,%esi
 222:	7e 0b                	jle    22f <memmove+0x1f>
    *dst++ = *src++;
 224:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 227:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 22a:	42                   	inc    %edx
  while(n-- > 0)
 22b:	39 f2                	cmp    %esi,%edx
 22d:	75 f5                	jne    224 <memmove+0x14>
  return vdst;
}
 22f:	5b                   	pop    %ebx
 230:	5e                   	pop    %esi
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 233:	b8 01 00 00 00       	mov    $0x1,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <exit>:
SYSCALL(exit)
 23b:	b8 02 00 00 00       	mov    $0x2,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <wait>:
SYSCALL(wait)
 243:	b8 03 00 00 00       	mov    $0x3,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <pipe>:
SYSCALL(pipe)
 24b:	b8 04 00 00 00       	mov    $0x4,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <read>:
SYSCALL(read)
 253:	b8 05 00 00 00       	mov    $0x5,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <write>:
SYSCALL(write)
 25b:	b8 10 00 00 00       	mov    $0x10,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <close>:
SYSCALL(close)
 263:	b8 15 00 00 00       	mov    $0x15,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <kill>:
SYSCALL(kill)
 26b:	b8 06 00 00 00       	mov    $0x6,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exec>:
SYSCALL(exec)
 273:	b8 07 00 00 00       	mov    $0x7,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <open>:
SYSCALL(open)
 27b:	b8 0f 00 00 00       	mov    $0xf,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <mknod>:
SYSCALL(mknod)
 283:	b8 11 00 00 00       	mov    $0x11,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <unlink>:
SYSCALL(unlink)
 28b:	b8 12 00 00 00       	mov    $0x12,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <fstat>:
SYSCALL(fstat)
 293:	b8 08 00 00 00       	mov    $0x8,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <link>:
SYSCALL(link)
 29b:	b8 13 00 00 00       	mov    $0x13,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <mkdir>:
SYSCALL(mkdir)
 2a3:	b8 14 00 00 00       	mov    $0x14,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <chdir>:
SYSCALL(chdir)
 2ab:	b8 09 00 00 00       	mov    $0x9,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <dup>:
SYSCALL(dup)
 2b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <getpid>:
SYSCALL(getpid)
 2bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <getppid>:
SYSCALL(getppid)
 2c3:	b8 17 00 00 00       	mov    $0x17,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <sbrk>:
SYSCALL(sbrk)
 2cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <sleep>:
SYSCALL(sleep)
 2d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <uptime>:
SYSCALL(uptime)
 2db:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <myfunction>:
SYSCALL(myfunction)
 2e3:	b8 16 00 00 00       	mov    $0x16,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <yield>:
SYSCALL(yield)
 2eb:	b8 18 00 00 00       	mov    $0x18,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <getlev>:
SYSCALL(getlev)
 2f3:	b8 19 00 00 00       	mov    $0x19,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <set_cpu_share>:
 2fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    
 303:	90                   	nop

00000304 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	56                   	push   %esi
 309:	53                   	push   %ebx
 30a:	83 ec 3c             	sub    $0x3c,%esp
 30d:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 30f:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 311:	8b 5d 08             	mov    0x8(%ebp),%ebx
 314:	85 db                	test   %ebx,%ebx
 316:	74 04                	je     31c <printint+0x18>
 318:	85 d2                	test   %edx,%edx
 31a:	78 5d                	js     379 <printint+0x75>
  neg = 0;
 31c:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 31e:	31 f6                	xor    %esi,%esi
 320:	eb 04                	jmp    326 <printint+0x22>
 322:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 324:	89 d6                	mov    %edx,%esi
 326:	31 d2                	xor    %edx,%edx
 328:	f7 f1                	div    %ecx
 32a:	8a 92 e0 06 00 00    	mov    0x6e0(%edx),%dl
 330:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 334:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 337:	85 c0                	test   %eax,%eax
 339:	75 e9                	jne    324 <printint+0x20>
  if(neg)
 33b:	85 db                	test   %ebx,%ebx
 33d:	74 08                	je     347 <printint+0x43>
    buf[i++] = '-';
 33f:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 344:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 347:	8d 5a ff             	lea    -0x1(%edx),%ebx
 34a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 354:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 357:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 35e:	00 
 35f:	89 74 24 04          	mov    %esi,0x4(%esp)
 363:	89 3c 24             	mov    %edi,(%esp)
 366:	e8 f0 fe ff ff       	call   25b <write>
  while(--i >= 0)
 36b:	4b                   	dec    %ebx
 36c:	83 fb ff             	cmp    $0xffffffff,%ebx
 36f:	75 df                	jne    350 <printint+0x4c>
    putc(fd, buf[i]);
}
 371:	83 c4 3c             	add    $0x3c,%esp
 374:	5b                   	pop    %ebx
 375:	5e                   	pop    %esi
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
    x = -xx;
 379:	f7 d8                	neg    %eax
    neg = 1;
 37b:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 380:	eb 9c                	jmp    31e <printint+0x1a>
 382:	66 90                	xchg   %ax,%ax

00000384 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	56                   	push   %esi
 389:	53                   	push   %ebx
 38a:	83 ec 3c             	sub    $0x3c,%esp
 38d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 393:	8a 03                	mov    (%ebx),%al
 395:	84 c0                	test   %al,%al
 397:	0f 84 bb 00 00 00    	je     458 <printf+0xd4>
printf(int fd, char *fmt, ...)
 39d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 39e:	8d 55 10             	lea    0x10(%ebp),%edx
 3a1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 3a4:	31 ff                	xor    %edi,%edi
 3a6:	eb 2f                	jmp    3d7 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3a8:	83 f9 25             	cmp    $0x25,%ecx
 3ab:	0f 84 af 00 00 00    	je     460 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 3b1:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 3b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bb:	00 
 3bc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c3:	89 34 24             	mov    %esi,(%esp)
 3c6:	e8 90 fe ff ff       	call   25b <write>
 3cb:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3cc:	8a 43 ff             	mov    -0x1(%ebx),%al
 3cf:	84 c0                	test   %al,%al
 3d1:	0f 84 81 00 00 00    	je     458 <printf+0xd4>
    c = fmt[i] & 0xff;
 3d7:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3da:	85 ff                	test   %edi,%edi
 3dc:	74 ca                	je     3a8 <printf+0x24>
      }
    } else if(state == '%'){
 3de:	83 ff 25             	cmp    $0x25,%edi
 3e1:	75 e8                	jne    3cb <printf+0x47>
      if(c == 'd'){
 3e3:	83 f9 64             	cmp    $0x64,%ecx
 3e6:	0f 84 14 01 00 00    	je     500 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ec:	83 f9 78             	cmp    $0x78,%ecx
 3ef:	74 7b                	je     46c <printf+0xe8>
 3f1:	83 f9 70             	cmp    $0x70,%ecx
 3f4:	74 76                	je     46c <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3f6:	83 f9 73             	cmp    $0x73,%ecx
 3f9:	0f 84 91 00 00 00    	je     490 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3ff:	83 f9 63             	cmp    $0x63,%ecx
 402:	0f 84 cc 00 00 00    	je     4d4 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 408:	83 f9 25             	cmp    $0x25,%ecx
 40b:	0f 84 13 01 00 00    	je     524 <printf+0x1a0>
 411:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 415:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41c:	00 
 41d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 420:	89 44 24 04          	mov    %eax,0x4(%esp)
 424:	89 34 24             	mov    %esi,(%esp)
 427:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 42a:	e8 2c fe ff ff       	call   25b <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 42f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 432:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 435:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43c:	00 
 43d:	8d 55 e7             	lea    -0x19(%ebp),%edx
 440:	89 54 24 04          	mov    %edx,0x4(%esp)
 444:	89 34 24             	mov    %esi,(%esp)
 447:	e8 0f fe ff ff       	call   25b <write>
      }
      state = 0;
 44c:	31 ff                	xor    %edi,%edi
 44e:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 44f:	8a 43 ff             	mov    -0x1(%ebx),%al
 452:	84 c0                	test   %al,%al
 454:	75 81                	jne    3d7 <printf+0x53>
 456:	66 90                	xchg   %ax,%ax
    }
  }
}
 458:	83 c4 3c             	add    $0x3c,%esp
 45b:	5b                   	pop    %ebx
 45c:	5e                   	pop    %esi
 45d:	5f                   	pop    %edi
 45e:	5d                   	pop    %ebp
 45f:	c3                   	ret    
        state = '%';
 460:	bf 25 00 00 00       	mov    $0x25,%edi
 465:	e9 61 ff ff ff       	jmp    3cb <printf+0x47>
 46a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 46c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 473:	b9 10 00 00 00       	mov    $0x10,%ecx
 478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 47b:	8b 10                	mov    (%eax),%edx
 47d:	89 f0                	mov    %esi,%eax
 47f:	e8 80 fe ff ff       	call   304 <printint>
        ap++;
 484:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 488:	31 ff                	xor    %edi,%edi
        ap++;
 48a:	e9 3c ff ff ff       	jmp    3cb <printf+0x47>
 48f:	90                   	nop
        s = (char*)*ap;
 490:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 493:	8b 3a                	mov    (%edx),%edi
        ap++;
 495:	83 c2 04             	add    $0x4,%edx
 498:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 49b:	85 ff                	test   %edi,%edi
 49d:	0f 84 a3 00 00 00    	je     546 <printf+0x1c2>
        while(*s != 0){
 4a3:	8a 07                	mov    (%edi),%al
 4a5:	84 c0                	test   %al,%al
 4a7:	74 24                	je     4cd <printf+0x149>
 4a9:	8d 76 00             	lea    0x0(%esi),%esi
 4ac:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b6:	00 
 4b7:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 4ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 4be:	89 34 24             	mov    %esi,(%esp)
 4c1:	e8 95 fd ff ff       	call   25b <write>
          s++;
 4c6:	47                   	inc    %edi
        while(*s != 0){
 4c7:	8a 07                	mov    (%edi),%al
 4c9:	84 c0                	test   %al,%al
 4cb:	75 df                	jne    4ac <printf+0x128>
      state = 0;
 4cd:	31 ff                	xor    %edi,%edi
 4cf:	e9 f7 fe ff ff       	jmp    3cb <printf+0x47>
        putc(fd, *ap);
 4d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4d7:	8b 02                	mov    (%edx),%eax
 4d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e3:	00 
 4e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	89 34 24             	mov    %esi,(%esp)
 4ee:	e8 68 fd ff ff       	call   25b <write>
        ap++;
 4f3:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4f7:	31 ff                	xor    %edi,%edi
 4f9:	e9 cd fe ff ff       	jmp    3cb <printf+0x47>
 4fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 500:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 507:	b1 0a                	mov    $0xa,%cl
 509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 50c:	8b 10                	mov    (%eax),%edx
 50e:	89 f0                	mov    %esi,%eax
 510:	e8 ef fd ff ff       	call   304 <printint>
        ap++;
 515:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 519:	66 31 ff             	xor    %di,%di
 51c:	e9 aa fe ff ff       	jmp    3cb <printf+0x47>
 521:	8d 76 00             	lea    0x0(%esi),%esi
 524:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 528:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52f:	00 
 530:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 533:	89 44 24 04          	mov    %eax,0x4(%esp)
 537:	89 34 24             	mov    %esi,(%esp)
 53a:	e8 1c fd ff ff       	call   25b <write>
      state = 0;
 53f:	31 ff                	xor    %edi,%edi
 541:	e9 85 fe ff ff       	jmp    3cb <printf+0x47>
          s = "(null)";
 546:	bf d9 06 00 00       	mov    $0x6d9,%edi
 54b:	e9 53 ff ff ff       	jmp    4a3 <printf+0x11f>

00000550 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 559:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55c:	a1 78 09 00 00       	mov    0x978,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 561:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 563:	39 d0                	cmp    %edx,%eax
 565:	72 11                	jb     578 <free+0x28>
 567:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 568:	39 c8                	cmp    %ecx,%eax
 56a:	72 04                	jb     570 <free+0x20>
 56c:	39 ca                	cmp    %ecx,%edx
 56e:	72 10                	jb     580 <free+0x30>
 570:	89 c8                	mov    %ecx,%eax
 572:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 574:	39 d0                	cmp    %edx,%eax
 576:	73 f0                	jae    568 <free+0x18>
 578:	39 ca                	cmp    %ecx,%edx
 57a:	72 04                	jb     580 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57c:	39 c8                	cmp    %ecx,%eax
 57e:	72 f0                	jb     570 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 580:	8b 73 fc             	mov    -0x4(%ebx),%esi
 583:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 586:	39 cf                	cmp    %ecx,%edi
 588:	74 1a                	je     5a4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 58a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 58d:	8b 48 04             	mov    0x4(%eax),%ecx
 590:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 593:	39 f2                	cmp    %esi,%edx
 595:	74 24                	je     5bb <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 597:	89 10                	mov    %edx,(%eax)
  freep = p;
 599:	a3 78 09 00 00       	mov    %eax,0x978
}
 59e:	5b                   	pop    %ebx
 59f:	5e                   	pop    %esi
 5a0:	5f                   	pop    %edi
 5a1:	5d                   	pop    %ebp
 5a2:	c3                   	ret    
 5a3:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5a4:	03 71 04             	add    0x4(%ecx),%esi
 5a7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5aa:	8b 08                	mov    (%eax),%ecx
 5ac:	8b 09                	mov    (%ecx),%ecx
 5ae:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b1:	8b 48 04             	mov    0x4(%eax),%ecx
 5b4:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5b7:	39 f2                	cmp    %esi,%edx
 5b9:	75 dc                	jne    597 <free+0x47>
    p->s.size += bp->s.size;
 5bb:	03 4b fc             	add    -0x4(%ebx),%ecx
 5be:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5c1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 5c6:	a3 78 09 00 00       	mov    %eax,0x978
}
 5cb:	5b                   	pop    %ebx
 5cc:	5e                   	pop    %esi
 5cd:	5f                   	pop    %edi
 5ce:	5d                   	pop    %ebp
 5cf:	c3                   	ret    

000005d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 75 08             	mov    0x8(%ebp),%esi
 5dc:	83 c6 07             	add    $0x7,%esi
 5df:	c1 ee 03             	shr    $0x3,%esi
 5e2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5e3:	8b 15 78 09 00 00    	mov    0x978,%edx
 5e9:	85 d2                	test   %edx,%edx
 5eb:	0f 84 8d 00 00 00    	je     67e <malloc+0xae>
 5f1:	8b 02                	mov    (%edx),%eax
 5f3:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5f6:	39 ce                	cmp    %ecx,%esi
 5f8:	76 52                	jbe    64c <malloc+0x7c>
 5fa:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 601:	eb 0a                	jmp    60d <malloc+0x3d>
 603:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 604:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 606:	8b 48 04             	mov    0x4(%eax),%ecx
 609:	39 ce                	cmp    %ecx,%esi
 60b:	76 3f                	jbe    64c <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 60d:	89 c2                	mov    %eax,%edx
 60f:	3b 05 78 09 00 00    	cmp    0x978,%eax
 615:	75 ed                	jne    604 <malloc+0x34>
  if(nu < 4096)
 617:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 61d:	76 4d                	jbe    66c <malloc+0x9c>
 61f:	89 d8                	mov    %ebx,%eax
 621:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 623:	89 04 24             	mov    %eax,(%esp)
 626:	e8 a0 fc ff ff       	call   2cb <sbrk>
  if(p == (char*)-1)
 62b:	83 f8 ff             	cmp    $0xffffffff,%eax
 62e:	74 18                	je     648 <malloc+0x78>
  hp->s.size = nu;
 630:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 633:	83 c0 08             	add    $0x8,%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 12 ff ff ff       	call   550 <free>
  return freep;
 63e:	8b 15 78 09 00 00    	mov    0x978,%edx
      if((p = morecore(nunits)) == 0)
 644:	85 d2                	test   %edx,%edx
 646:	75 bc                	jne    604 <malloc+0x34>
        return 0;
 648:	31 c0                	xor    %eax,%eax
 64a:	eb 18                	jmp    664 <malloc+0x94>
      if(p->s.size == nunits)
 64c:	39 ce                	cmp    %ecx,%esi
 64e:	74 28                	je     678 <malloc+0xa8>
        p->s.size -= nunits;
 650:	29 f1                	sub    %esi,%ecx
 652:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 655:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 658:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 65b:	89 15 78 09 00 00    	mov    %edx,0x978
      return (void*)(p + 1);
 661:	83 c0 08             	add    $0x8,%eax
  }
}
 664:	83 c4 1c             	add    $0x1c,%esp
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
  if(nu < 4096)
 66c:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 671:	bf 00 10 00 00       	mov    $0x1000,%edi
 676:	eb ab                	jmp    623 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 678:	8b 08                	mov    (%eax),%ecx
 67a:	89 0a                	mov    %ecx,(%edx)
 67c:	eb dd                	jmp    65b <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 67e:	c7 05 78 09 00 00 7c 	movl   $0x97c,0x978
 685:	09 00 00 
 688:	c7 05 7c 09 00 00 7c 	movl   $0x97c,0x97c
 68f:	09 00 00 
    base.s.size = 0;
 692:	c7 05 80 09 00 00 00 	movl   $0x0,0x980
 699:	00 00 00 
 69c:	b8 7c 09 00 00       	mov    $0x97c,%eax
 6a1:	e9 54 ff ff ff       	jmp    5fa <malloc+0x2a>
