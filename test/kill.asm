
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  12:	83 fe 01             	cmp    $0x1,%esi
  15:	7e 22                	jle    39 <main+0x39>
  17:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  1c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 9d 01 00 00       	call   1c4 <atoi>
  27:	89 04 24             	mov    %eax,(%esp)
  2a:	e8 20 02 00 00       	call   24f <kill>
  for(i=1; i<argc; i++)
  2f:	43                   	inc    %ebx
  30:	39 f3                	cmp    %esi,%ebx
  32:	75 e8                	jne    1c <main+0x1c>
  exit();
  34:	e8 e6 01 00 00       	call   21f <exit>
    printf(2, "usage: kill pid...\n");
  39:	c7 44 24 04 8a 06 00 	movl   $0x68a,0x4(%esp)
  40:	00 
  41:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  48:	e8 1b 03 00 00       	call   368 <printf>
    exit();
  4d:	e8 cd 01 00 00       	call   21f <exit>
  52:	66 90                	xchg   %ax,%ax

00000054 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	53                   	push   %ebx
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5e:	89 c2                	mov    %eax,%edx
  60:	8a 19                	mov    (%ecx),%bl
  62:	88 1a                	mov    %bl,(%edx)
  64:	42                   	inc    %edx
  65:	41                   	inc    %ecx
  66:	84 db                	test   %bl,%bl
  68:	75 f6                	jne    60 <strcpy+0xc>
    ;
  return os;
}
  6a:	5b                   	pop    %ebx
  6b:	5d                   	pop    %ebp
  6c:	c3                   	ret    
  6d:	8d 76 00             	lea    0x0(%esi),%esi

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	56                   	push   %esi
  74:	53                   	push   %ebx
  75:	8b 55 08             	mov    0x8(%ebp),%edx
  78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  7b:	0f b6 02             	movzbl (%edx),%eax
  7e:	0f b6 19             	movzbl (%ecx),%ebx
  81:	84 c0                	test   %al,%al
  83:	75 14                	jne    99 <strcmp+0x29>
  85:	eb 1d                	jmp    a4 <strcmp+0x34>
  87:	90                   	nop
    p++, q++;
  88:	42                   	inc    %edx
  89:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  8c:	0f b6 02             	movzbl (%edx),%eax
  8f:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  93:	84 c0                	test   %al,%al
  95:	74 0d                	je     a4 <strcmp+0x34>
    p++, q++;
  97:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  99:	38 d8                	cmp    %bl,%al
  9b:	74 eb                	je     88 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  9d:	29 d8                	sub    %ebx,%eax
}
  9f:	5b                   	pop    %ebx
  a0:	5e                   	pop    %esi
  a1:	5d                   	pop    %ebp
  a2:	c3                   	ret    
  a3:	90                   	nop
  while(*p && *p == *q)
  a4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  a6:	29 d8                	sub    %ebx,%eax
}
  a8:	5b                   	pop    %ebx
  a9:	5e                   	pop    %esi
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <strlen>:

uint
strlen(char *s)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b2:	80 39 00             	cmpb   $0x0,(%ecx)
  b5:	74 10                	je     c7 <strlen+0x1b>
  b7:	31 d2                	xor    %edx,%edx
  b9:	8d 76 00             	lea    0x0(%esi),%esi
  bc:	42                   	inc    %edx
  bd:	89 d0                	mov    %edx,%eax
  bf:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c3:	75 f7                	jne    bc <strlen+0x10>
    ;
  return n;
}
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c7:	31 c0                	xor    %eax,%eax
}
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    
  cb:	90                   	nop

000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	57                   	push   %edi
  d0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d3:	89 d7                	mov    %edx,%edi
  d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	fc                   	cld    
  dc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  de:	89 d0                	mov    %edx,%eax
  e0:	5f                   	pop    %edi
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    
  e3:	90                   	nop

000000e4 <strchr>:

char*
strchr(const char *s, char c)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  ed:	8a 10                	mov    (%eax),%dl
  ef:	84 d2                	test   %dl,%dl
  f1:	75 0c                	jne    ff <strchr+0x1b>
  f3:	eb 13                	jmp    108 <strchr+0x24>
  f5:	8d 76 00             	lea    0x0(%esi),%esi
  f8:	40                   	inc    %eax
  f9:	8a 10                	mov    (%eax),%dl
  fb:	84 d2                	test   %dl,%dl
  fd:	74 09                	je     108 <strchr+0x24>
    if(*s == c)
  ff:	38 ca                	cmp    %cl,%dl
 101:	75 f5                	jne    f8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 108:	31 c0                	xor    %eax,%eax
}
 10a:	5d                   	pop    %ebp
 10b:	c3                   	ret    

0000010c <gets>:

char*
gets(char *buf, int max)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	57                   	push   %edi
 110:	56                   	push   %esi
 111:	53                   	push   %ebx
 112:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 117:	8d 7d e7             	lea    -0x19(%ebp),%edi
 11a:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 11c:	8d 73 01             	lea    0x1(%ebx),%esi
 11f:	3b 75 0c             	cmp    0xc(%ebp),%esi
 122:	7d 40                	jge    164 <gets+0x58>
    cc = read(0, &c, 1);
 124:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 12b:	00 
 12c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 137:	e8 fb 00 00 00       	call   237 <read>
    if(cc < 1)
 13c:	85 c0                	test   %eax,%eax
 13e:	7e 24                	jle    164 <gets+0x58>
      break;
    buf[i++] = c;
 140:	8a 45 e7             	mov    -0x19(%ebp),%al
 143:	8b 55 08             	mov    0x8(%ebp),%edx
 146:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 14a:	3c 0a                	cmp    $0xa,%al
 14c:	74 06                	je     154 <gets+0x48>
 14e:	89 f3                	mov    %esi,%ebx
 150:	3c 0d                	cmp    $0xd,%al
 152:	75 c8                	jne    11c <gets+0x10>
      break;
  }
  buf[i] = '\0';
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 15b:	83 c4 2c             	add    $0x2c,%esp
 15e:	5b                   	pop    %ebx
 15f:	5e                   	pop    %esi
 160:	5f                   	pop    %edi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop
    if(cc < 1)
 164:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 16d:	83 c4 2c             	add    $0x2c,%esp
 170:	5b                   	pop    %ebx
 171:	5e                   	pop    %esi
 172:	5f                   	pop    %edi
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    
 175:	8d 76 00             	lea    0x0(%esi),%esi

00000178 <stat>:

int
stat(char *n, struct stat *st)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	56                   	push   %esi
 17c:	53                   	push   %ebx
 17d:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 187:	00 
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	89 04 24             	mov    %eax,(%esp)
 18e:	e8 cc 00 00 00       	call   25f <open>
 193:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 195:	85 c0                	test   %eax,%eax
 197:	78 23                	js     1bc <stat+0x44>
    return -1;
  r = fstat(fd, st);
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a0:	89 1c 24             	mov    %ebx,(%esp)
 1a3:	e8 cf 00 00 00       	call   277 <fstat>
 1a8:	89 c6                	mov    %eax,%esi
  close(fd);
 1aa:	89 1c 24             	mov    %ebx,(%esp)
 1ad:	e8 95 00 00 00       	call   247 <close>
  return r;
}
 1b2:	89 f0                	mov    %esi,%eax
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	5b                   	pop    %ebx
 1b8:	5e                   	pop    %esi
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    
 1bb:	90                   	nop
    return -1;
 1bc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c1:	eb ef                	jmp    1b2 <stat+0x3a>
 1c3:	90                   	nop

000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	53                   	push   %ebx
 1c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cb:	0f be 11             	movsbl (%ecx),%edx
 1ce:	8d 42 d0             	lea    -0x30(%edx),%eax
 1d1:	3c 09                	cmp    $0x9,%al
 1d3:	b8 00 00 00 00       	mov    $0x0,%eax
 1d8:	77 15                	ja     1ef <atoi+0x2b>
 1da:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1dc:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1df:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1e3:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 1e4:	0f be 11             	movsbl (%ecx),%edx
 1e7:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ea:	80 fb 09             	cmp    $0x9,%bl
 1ed:	76 ed                	jbe    1dc <atoi+0x18>
  return n;
}
 1ef:	5b                   	pop    %ebx
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    
 1f2:	66 90                	xchg   %ax,%ax

000001f4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	56                   	push   %esi
 1f8:	53                   	push   %ebx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ff:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 202:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 204:	85 f6                	test   %esi,%esi
 206:	7e 0b                	jle    213 <memmove+0x1f>
    *dst++ = *src++;
 208:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 20b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 20e:	42                   	inc    %edx
  while(n-- > 0)
 20f:	39 f2                	cmp    %esi,%edx
 211:	75 f5                	jne    208 <memmove+0x14>
  return vdst;
}
 213:	5b                   	pop    %ebx
 214:	5e                   	pop    %esi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    

00000217 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <exit>:
SYSCALL(exit)
 21f:	b8 02 00 00 00       	mov    $0x2,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <wait>:
SYSCALL(wait)
 227:	b8 03 00 00 00       	mov    $0x3,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <pipe>:
SYSCALL(pipe)
 22f:	b8 04 00 00 00       	mov    $0x4,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <read>:
SYSCALL(read)
 237:	b8 05 00 00 00       	mov    $0x5,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <write>:
SYSCALL(write)
 23f:	b8 10 00 00 00       	mov    $0x10,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <close>:
SYSCALL(close)
 247:	b8 15 00 00 00       	mov    $0x15,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <kill>:
SYSCALL(kill)
 24f:	b8 06 00 00 00       	mov    $0x6,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <exec>:
SYSCALL(exec)
 257:	b8 07 00 00 00       	mov    $0x7,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <open>:
SYSCALL(open)
 25f:	b8 0f 00 00 00       	mov    $0xf,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mknod>:
SYSCALL(mknod)
 267:	b8 11 00 00 00       	mov    $0x11,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <unlink>:
SYSCALL(unlink)
 26f:	b8 12 00 00 00       	mov    $0x12,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <fstat>:
SYSCALL(fstat)
 277:	b8 08 00 00 00       	mov    $0x8,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <link>:
SYSCALL(link)
 27f:	b8 13 00 00 00       	mov    $0x13,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <mkdir>:
SYSCALL(mkdir)
 287:	b8 14 00 00 00       	mov    $0x14,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <chdir>:
SYSCALL(chdir)
 28f:	b8 09 00 00 00       	mov    $0x9,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <dup>:
SYSCALL(dup)
 297:	b8 0a 00 00 00       	mov    $0xa,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <getpid>:
SYSCALL(getpid)
 29f:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <getppid>:
SYSCALL(getppid)
 2a7:	b8 17 00 00 00       	mov    $0x17,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <sbrk>:
SYSCALL(sbrk)
 2af:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <sleep>:
SYSCALL(sleep)
 2b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <uptime>:
SYSCALL(uptime)
 2bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <myfunction>:
SYSCALL(myfunction)
 2c7:	b8 16 00 00 00       	mov    $0x16,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <yield>:
SYSCALL(yield)
 2cf:	b8 18 00 00 00       	mov    $0x18,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <getlev>:
SYSCALL(getlev)
 2d7:	b8 19 00 00 00       	mov    $0x19,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <set_cpu_share>:
 2df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    
 2e7:	90                   	nop

000002e8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	57                   	push   %edi
 2ec:	56                   	push   %esi
 2ed:	53                   	push   %ebx
 2ee:	83 ec 3c             	sub    $0x3c,%esp
 2f1:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2f3:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 2f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2f8:	85 db                	test   %ebx,%ebx
 2fa:	74 04                	je     300 <printint+0x18>
 2fc:	85 d2                	test   %edx,%edx
 2fe:	78 5d                	js     35d <printint+0x75>
  neg = 0;
 300:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 302:	31 f6                	xor    %esi,%esi
 304:	eb 04                	jmp    30a <printint+0x22>
 306:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 308:	89 d6                	mov    %edx,%esi
 30a:	31 d2                	xor    %edx,%edx
 30c:	f7 f1                	div    %ecx
 30e:	8a 92 a5 06 00 00    	mov    0x6a5(%edx),%dl
 314:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 318:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 31b:	85 c0                	test   %eax,%eax
 31d:	75 e9                	jne    308 <printint+0x20>
  if(neg)
 31f:	85 db                	test   %ebx,%ebx
 321:	74 08                	je     32b <printint+0x43>
    buf[i++] = '-';
 323:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 328:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 32b:	8d 5a ff             	lea    -0x1(%edx),%ebx
 32e:	8d 75 d7             	lea    -0x29(%ebp),%esi
 331:	8d 76 00             	lea    0x0(%esi),%esi
 334:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 338:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 33b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 342:	00 
 343:	89 74 24 04          	mov    %esi,0x4(%esp)
 347:	89 3c 24             	mov    %edi,(%esp)
 34a:	e8 f0 fe ff ff       	call   23f <write>
  while(--i >= 0)
 34f:	4b                   	dec    %ebx
 350:	83 fb ff             	cmp    $0xffffffff,%ebx
 353:	75 df                	jne    334 <printint+0x4c>
    putc(fd, buf[i]);
}
 355:	83 c4 3c             	add    $0x3c,%esp
 358:	5b                   	pop    %ebx
 359:	5e                   	pop    %esi
 35a:	5f                   	pop    %edi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
    x = -xx;
 35d:	f7 d8                	neg    %eax
    neg = 1;
 35f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 364:	eb 9c                	jmp    302 <printint+0x1a>
 366:	66 90                	xchg   %ax,%ax

00000368 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 3c             	sub    $0x3c,%esp
 371:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 374:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 377:	8a 03                	mov    (%ebx),%al
 379:	84 c0                	test   %al,%al
 37b:	0f 84 bb 00 00 00    	je     43c <printf+0xd4>
printf(int fd, char *fmt, ...)
 381:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 382:	8d 55 10             	lea    0x10(%ebp),%edx
 385:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 388:	31 ff                	xor    %edi,%edi
 38a:	eb 2f                	jmp    3bb <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 38c:	83 f9 25             	cmp    $0x25,%ecx
 38f:	0f 84 af 00 00 00    	je     444 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 395:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 398:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39f:	00 
 3a0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a7:	89 34 24             	mov    %esi,(%esp)
 3aa:	e8 90 fe ff ff       	call   23f <write>
 3af:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3b0:	8a 43 ff             	mov    -0x1(%ebx),%al
 3b3:	84 c0                	test   %al,%al
 3b5:	0f 84 81 00 00 00    	je     43c <printf+0xd4>
    c = fmt[i] & 0xff;
 3bb:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3be:	85 ff                	test   %edi,%edi
 3c0:	74 ca                	je     38c <printf+0x24>
      }
    } else if(state == '%'){
 3c2:	83 ff 25             	cmp    $0x25,%edi
 3c5:	75 e8                	jne    3af <printf+0x47>
      if(c == 'd'){
 3c7:	83 f9 64             	cmp    $0x64,%ecx
 3ca:	0f 84 14 01 00 00    	je     4e4 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3d0:	83 f9 78             	cmp    $0x78,%ecx
 3d3:	74 7b                	je     450 <printf+0xe8>
 3d5:	83 f9 70             	cmp    $0x70,%ecx
 3d8:	74 76                	je     450 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3da:	83 f9 73             	cmp    $0x73,%ecx
 3dd:	0f 84 91 00 00 00    	je     474 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e3:	83 f9 63             	cmp    $0x63,%ecx
 3e6:	0f 84 cc 00 00 00    	je     4b8 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3ec:	83 f9 25             	cmp    $0x25,%ecx
 3ef:	0f 84 13 01 00 00    	je     508 <printf+0x1a0>
 3f5:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 3f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 400:	00 
 401:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 404:	89 44 24 04          	mov    %eax,0x4(%esp)
 408:	89 34 24             	mov    %esi,(%esp)
 40b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 40e:	e8 2c fe ff ff       	call   23f <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 413:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 416:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 419:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 420:	00 
 421:	8d 55 e7             	lea    -0x19(%ebp),%edx
 424:	89 54 24 04          	mov    %edx,0x4(%esp)
 428:	89 34 24             	mov    %esi,(%esp)
 42b:	e8 0f fe ff ff       	call   23f <write>
      }
      state = 0;
 430:	31 ff                	xor    %edi,%edi
 432:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 433:	8a 43 ff             	mov    -0x1(%ebx),%al
 436:	84 c0                	test   %al,%al
 438:	75 81                	jne    3bb <printf+0x53>
 43a:	66 90                	xchg   %ax,%ax
    }
  }
}
 43c:	83 c4 3c             	add    $0x3c,%esp
 43f:	5b                   	pop    %ebx
 440:	5e                   	pop    %esi
 441:	5f                   	pop    %edi
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
        state = '%';
 444:	bf 25 00 00 00       	mov    $0x25,%edi
 449:	e9 61 ff ff ff       	jmp    3af <printf+0x47>
 44e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 457:	b9 10 00 00 00       	mov    $0x10,%ecx
 45c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 45f:	8b 10                	mov    (%eax),%edx
 461:	89 f0                	mov    %esi,%eax
 463:	e8 80 fe ff ff       	call   2e8 <printint>
        ap++;
 468:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 46c:	31 ff                	xor    %edi,%edi
        ap++;
 46e:	e9 3c ff ff ff       	jmp    3af <printf+0x47>
 473:	90                   	nop
        s = (char*)*ap;
 474:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 477:	8b 3a                	mov    (%edx),%edi
        ap++;
 479:	83 c2 04             	add    $0x4,%edx
 47c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 47f:	85 ff                	test   %edi,%edi
 481:	0f 84 a3 00 00 00    	je     52a <printf+0x1c2>
        while(*s != 0){
 487:	8a 07                	mov    (%edi),%al
 489:	84 c0                	test   %al,%al
 48b:	74 24                	je     4b1 <printf+0x149>
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 493:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49a:	00 
 49b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 49e:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a2:	89 34 24             	mov    %esi,(%esp)
 4a5:	e8 95 fd ff ff       	call   23f <write>
          s++;
 4aa:	47                   	inc    %edi
        while(*s != 0){
 4ab:	8a 07                	mov    (%edi),%al
 4ad:	84 c0                	test   %al,%al
 4af:	75 df                	jne    490 <printf+0x128>
      state = 0;
 4b1:	31 ff                	xor    %edi,%edi
 4b3:	e9 f7 fe ff ff       	jmp    3af <printf+0x47>
        putc(fd, *ap);
 4b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4bb:	8b 02                	mov    (%edx),%eax
 4bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c7:	00 
 4c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	89 34 24             	mov    %esi,(%esp)
 4d2:	e8 68 fd ff ff       	call   23f <write>
        ap++;
 4d7:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4db:	31 ff                	xor    %edi,%edi
 4dd:	e9 cd fe ff ff       	jmp    3af <printf+0x47>
 4e2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 4e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4eb:	b1 0a                	mov    $0xa,%cl
 4ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4f0:	8b 10                	mov    (%eax),%edx
 4f2:	89 f0                	mov    %esi,%eax
 4f4:	e8 ef fd ff ff       	call   2e8 <printint>
        ap++;
 4f9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4fd:	66 31 ff             	xor    %di,%di
 500:	e9 aa fe ff ff       	jmp    3af <printf+0x47>
 505:	8d 76 00             	lea    0x0(%esi),%esi
 508:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 50c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 513:	00 
 514:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	89 34 24             	mov    %esi,(%esp)
 51e:	e8 1c fd ff ff       	call   23f <write>
      state = 0;
 523:	31 ff                	xor    %edi,%edi
 525:	e9 85 fe ff ff       	jmp    3af <printf+0x47>
          s = "(null)";
 52a:	bf 9e 06 00 00       	mov    $0x69e,%edi
 52f:	e9 53 ff ff ff       	jmp    487 <printf+0x11f>

00000534 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	57                   	push   %edi
 538:	56                   	push   %esi
 539:	53                   	push   %ebx
 53a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 53d:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 540:	a1 3c 09 00 00       	mov    0x93c,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 545:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 547:	39 d0                	cmp    %edx,%eax
 549:	72 11                	jb     55c <free+0x28>
 54b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 54c:	39 c8                	cmp    %ecx,%eax
 54e:	72 04                	jb     554 <free+0x20>
 550:	39 ca                	cmp    %ecx,%edx
 552:	72 10                	jb     564 <free+0x30>
 554:	89 c8                	mov    %ecx,%eax
 556:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 558:	39 d0                	cmp    %edx,%eax
 55a:	73 f0                	jae    54c <free+0x18>
 55c:	39 ca                	cmp    %ecx,%edx
 55e:	72 04                	jb     564 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 560:	39 c8                	cmp    %ecx,%eax
 562:	72 f0                	jb     554 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 564:	8b 73 fc             	mov    -0x4(%ebx),%esi
 567:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 56a:	39 cf                	cmp    %ecx,%edi
 56c:	74 1a                	je     588 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 56e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 571:	8b 48 04             	mov    0x4(%eax),%ecx
 574:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 577:	39 f2                	cmp    %esi,%edx
 579:	74 24                	je     59f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 57b:	89 10                	mov    %edx,(%eax)
  freep = p;
 57d:	a3 3c 09 00 00       	mov    %eax,0x93c
}
 582:	5b                   	pop    %ebx
 583:	5e                   	pop    %esi
 584:	5f                   	pop    %edi
 585:	5d                   	pop    %ebp
 586:	c3                   	ret    
 587:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 588:	03 71 04             	add    0x4(%ecx),%esi
 58b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 58e:	8b 08                	mov    (%eax),%ecx
 590:	8b 09                	mov    (%ecx),%ecx
 592:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 595:	8b 48 04             	mov    0x4(%eax),%ecx
 598:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 59b:	39 f2                	cmp    %esi,%edx
 59d:	75 dc                	jne    57b <free+0x47>
    p->s.size += bp->s.size;
 59f:	03 4b fc             	add    -0x4(%ebx),%ecx
 5a2:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5a5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5a8:	89 10                	mov    %edx,(%eax)
  freep = p;
 5aa:	a3 3c 09 00 00       	mov    %eax,0x93c
}
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    

000005b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5bd:	8b 75 08             	mov    0x8(%ebp),%esi
 5c0:	83 c6 07             	add    $0x7,%esi
 5c3:	c1 ee 03             	shr    $0x3,%esi
 5c6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5c7:	8b 15 3c 09 00 00    	mov    0x93c,%edx
 5cd:	85 d2                	test   %edx,%edx
 5cf:	0f 84 8d 00 00 00    	je     662 <malloc+0xae>
 5d5:	8b 02                	mov    (%edx),%eax
 5d7:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5da:	39 ce                	cmp    %ecx,%esi
 5dc:	76 52                	jbe    630 <malloc+0x7c>
 5de:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 5e5:	eb 0a                	jmp    5f1 <malloc+0x3d>
 5e7:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ea:	8b 48 04             	mov    0x4(%eax),%ecx
 5ed:	39 ce                	cmp    %ecx,%esi
 5ef:	76 3f                	jbe    630 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5f1:	89 c2                	mov    %eax,%edx
 5f3:	3b 05 3c 09 00 00    	cmp    0x93c,%eax
 5f9:	75 ed                	jne    5e8 <malloc+0x34>
  if(nu < 4096)
 5fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 601:	76 4d                	jbe    650 <malloc+0x9c>
 603:	89 d8                	mov    %ebx,%eax
 605:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 a0 fc ff ff       	call   2af <sbrk>
  if(p == (char*)-1)
 60f:	83 f8 ff             	cmp    $0xffffffff,%eax
 612:	74 18                	je     62c <malloc+0x78>
  hp->s.size = nu;
 614:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 617:	83 c0 08             	add    $0x8,%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 12 ff ff ff       	call   534 <free>
  return freep;
 622:	8b 15 3c 09 00 00    	mov    0x93c,%edx
      if((p = morecore(nunits)) == 0)
 628:	85 d2                	test   %edx,%edx
 62a:	75 bc                	jne    5e8 <malloc+0x34>
        return 0;
 62c:	31 c0                	xor    %eax,%eax
 62e:	eb 18                	jmp    648 <malloc+0x94>
      if(p->s.size == nunits)
 630:	39 ce                	cmp    %ecx,%esi
 632:	74 28                	je     65c <malloc+0xa8>
        p->s.size -= nunits;
 634:	29 f1                	sub    %esi,%ecx
 636:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 639:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 63c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 63f:	89 15 3c 09 00 00    	mov    %edx,0x93c
      return (void*)(p + 1);
 645:	83 c0 08             	add    $0x8,%eax
  }
}
 648:	83 c4 1c             	add    $0x1c,%esp
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    
  if(nu < 4096)
 650:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 655:	bf 00 10 00 00       	mov    $0x1000,%edi
 65a:	eb ab                	jmp    607 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 65c:	8b 08                	mov    (%eax),%ecx
 65e:	89 0a                	mov    %ecx,(%edx)
 660:	eb dd                	jmp    63f <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 662:	c7 05 3c 09 00 00 40 	movl   $0x940,0x93c
 669:	09 00 00 
 66c:	c7 05 40 09 00 00 40 	movl   $0x940,0x940
 673:	09 00 00 
    base.s.size = 0;
 676:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 67d:	00 00 00 
 680:	b8 40 09 00 00       	mov    $0x940,%eax
 685:	e9 54 ff ff ff       	jmp    5de <malloc+0x2a>
