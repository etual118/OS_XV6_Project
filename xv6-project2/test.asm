
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "syscall.h"
#include "types.h"
#include "user.h"

int main(int argc, char** argv){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 e4 f0             	and    $0xfffffff0,%esp
   8:	83 ec 10             	sub    $0x10,%esp
    int pid, ppid;
    pid = getpid();
   b:	e8 8b 02 00 00       	call   29b <getpid>
  10:	89 c3                	mov    %eax,%ebx
    ppid = getppid();
  12:	e8 8c 02 00 00       	call   2a3 <getppid>
  17:	89 c6                	mov    %eax,%esi
    printf(1,"my pid is %d\n", pid);
  19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1d:	c7 44 24 04 86 06 00 	movl   $0x686,0x4(%esp)
  24:	00 
  25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2c:	e8 33 03 00 00       	call   364 <printf>
    printf(1,"my ppid is %d\n", ppid);
  31:	89 74 24 08          	mov    %esi,0x8(%esp)
  35:	c7 44 24 04 94 06 00 	movl   $0x694,0x4(%esp)
  3c:	00 
  3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  44:	e8 1b 03 00 00       	call   364 <printf>
    exit();
  49:	e8 cd 01 00 00       	call   21b <exit>
  4e:	66 90                	xchg   %ax,%ax

00000050 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 c2                	mov    %eax,%edx
  5c:	8a 19                	mov    (%ecx),%bl
  5e:	88 1a                	mov    %bl,(%edx)
  60:	42                   	inc    %edx
  61:	41                   	inc    %ecx
  62:	84 db                	test   %bl,%bl
  64:	75 f6                	jne    5c <strcpy+0xc>
    ;
  return os;
}
  66:	5b                   	pop    %ebx
  67:	5d                   	pop    %ebp
  68:	c3                   	ret    
  69:	8d 76 00             	lea    0x0(%esi),%esi

0000006c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	56                   	push   %esi
  70:	53                   	push   %ebx
  71:	8b 55 08             	mov    0x8(%ebp),%edx
  74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  77:	0f b6 02             	movzbl (%edx),%eax
  7a:	0f b6 19             	movzbl (%ecx),%ebx
  7d:	84 c0                	test   %al,%al
  7f:	75 14                	jne    95 <strcmp+0x29>
  81:	eb 1d                	jmp    a0 <strcmp+0x34>
  83:	90                   	nop
    p++, q++;
  84:	42                   	inc    %edx
  85:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  88:	0f b6 02             	movzbl (%edx),%eax
  8b:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  8f:	84 c0                	test   %al,%al
  91:	74 0d                	je     a0 <strcmp+0x34>
    p++, q++;
  93:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  95:	38 d8                	cmp    %bl,%al
  97:	74 eb                	je     84 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  99:	29 d8                	sub    %ebx,%eax
}
  9b:	5b                   	pop    %ebx
  9c:	5e                   	pop    %esi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    
  9f:	90                   	nop
  while(*p && *p == *q)
  a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  a2:	29 d8                	sub    %ebx,%eax
}
  a4:	5b                   	pop    %ebx
  a5:	5e                   	pop    %esi
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ae:	80 39 00             	cmpb   $0x0,(%ecx)
  b1:	74 10                	je     c3 <strlen+0x1b>
  b3:	31 d2                	xor    %edx,%edx
  b5:	8d 76 00             	lea    0x0(%esi),%esi
  b8:	42                   	inc    %edx
  b9:	89 d0                	mov    %edx,%eax
  bb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  bf:	75 f7                	jne    b8 <strlen+0x10>
    ;
  return n;
}
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c3:	31 c0                	xor    %eax,%eax
}
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop

000000c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	57                   	push   %edi
  cc:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  cf:	89 d7                	mov    %edx,%edi
  d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	fc                   	cld    
  d8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  da:	89 d0                	mov    %edx,%eax
  dc:	5f                   	pop    %edi
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  e9:	8a 10                	mov    (%eax),%dl
  eb:	84 d2                	test   %dl,%dl
  ed:	75 0c                	jne    fb <strchr+0x1b>
  ef:	eb 13                	jmp    104 <strchr+0x24>
  f1:	8d 76 00             	lea    0x0(%esi),%esi
  f4:	40                   	inc    %eax
  f5:	8a 10                	mov    (%eax),%dl
  f7:	84 d2                	test   %dl,%dl
  f9:	74 09                	je     104 <strchr+0x24>
    if(*s == c)
  fb:	38 ca                	cmp    %cl,%dl
  fd:	75 f5                	jne    f4 <strchr+0x14>
      return (char*)s;
  return 0;
}
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    
 101:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 104:	31 c0                	xor    %eax,%eax
}
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    

00000108 <gets>:

char*
gets(char *buf, int max)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	57                   	push   %edi
 10c:	56                   	push   %esi
 10d:	53                   	push   %ebx
 10e:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 111:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 113:	8d 7d e7             	lea    -0x19(%ebp),%edi
 116:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 118:	8d 73 01             	lea    0x1(%ebx),%esi
 11b:	3b 75 0c             	cmp    0xc(%ebp),%esi
 11e:	7d 40                	jge    160 <gets+0x58>
    cc = read(0, &c, 1);
 120:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 127:	00 
 128:	89 7c 24 04          	mov    %edi,0x4(%esp)
 12c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 133:	e8 fb 00 00 00       	call   233 <read>
    if(cc < 1)
 138:	85 c0                	test   %eax,%eax
 13a:	7e 24                	jle    160 <gets+0x58>
      break;
    buf[i++] = c;
 13c:	8a 45 e7             	mov    -0x19(%ebp),%al
 13f:	8b 55 08             	mov    0x8(%ebp),%edx
 142:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 146:	3c 0a                	cmp    $0xa,%al
 148:	74 06                	je     150 <gets+0x48>
 14a:	89 f3                	mov    %esi,%ebx
 14c:	3c 0d                	cmp    $0xd,%al
 14e:	75 c8                	jne    118 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 157:	83 c4 2c             	add    $0x2c,%esp
 15a:	5b                   	pop    %ebx
 15b:	5e                   	pop    %esi
 15c:	5f                   	pop    %edi
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    
 15f:	90                   	nop
    if(cc < 1)
 160:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 169:	83 c4 2c             	add    $0x2c,%esp
 16c:	5b                   	pop    %ebx
 16d:	5e                   	pop    %esi
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	8d 76 00             	lea    0x0(%esi),%esi

00000174 <stat>:

int
stat(char *n, struct stat *st)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	56                   	push   %esi
 178:	53                   	push   %ebx
 179:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 183:	00 
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	89 04 24             	mov    %eax,(%esp)
 18a:	e8 cc 00 00 00       	call   25b <open>
 18f:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 191:	85 c0                	test   %eax,%eax
 193:	78 23                	js     1b8 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	89 1c 24             	mov    %ebx,(%esp)
 19f:	e8 cf 00 00 00       	call   273 <fstat>
 1a4:	89 c6                	mov    %eax,%esi
  close(fd);
 1a6:	89 1c 24             	mov    %ebx,(%esp)
 1a9:	e8 95 00 00 00       	call   243 <close>
  return r;
}
 1ae:	89 f0                	mov    %esi,%eax
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	5b                   	pop    %ebx
 1b4:	5e                   	pop    %esi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	90                   	nop
    return -1;
 1b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bd:	eb ef                	jmp    1ae <stat+0x3a>
 1bf:	90                   	nop

000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f be 11             	movsbl (%ecx),%edx
 1ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 1cd:	3c 09                	cmp    $0x9,%al
 1cf:	b8 00 00 00 00       	mov    $0x0,%eax
 1d4:	77 15                	ja     1eb <atoi+0x2b>
 1d6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1d8:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1db:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1df:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 1e0:	0f be 11             	movsbl (%ecx),%edx
 1e3:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1e6:	80 fb 09             	cmp    $0x9,%bl
 1e9:	76 ed                	jbe    1d8 <atoi+0x18>
  return n;
}
 1eb:	5b                   	pop    %ebx
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1fb:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 1fe:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 200:	85 f6                	test   %esi,%esi
 202:	7e 0b                	jle    20f <memmove+0x1f>
    *dst++ = *src++;
 204:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 207:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 20a:	42                   	inc    %edx
  while(n-- > 0)
 20b:	39 f2                	cmp    %esi,%edx
 20d:	75 f5                	jne    204 <memmove+0x14>
  return vdst;
}
 20f:	5b                   	pop    %ebx
 210:	5e                   	pop    %esi
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    

00000213 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 213:	b8 01 00 00 00       	mov    $0x1,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <exit>:
SYSCALL(exit)
 21b:	b8 02 00 00 00       	mov    $0x2,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <wait>:
SYSCALL(wait)
 223:	b8 03 00 00 00       	mov    $0x3,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <pipe>:
SYSCALL(pipe)
 22b:	b8 04 00 00 00       	mov    $0x4,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <read>:
SYSCALL(read)
 233:	b8 05 00 00 00       	mov    $0x5,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <write>:
SYSCALL(write)
 23b:	b8 10 00 00 00       	mov    $0x10,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <close>:
SYSCALL(close)
 243:	b8 15 00 00 00       	mov    $0x15,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <kill>:
SYSCALL(kill)
 24b:	b8 06 00 00 00       	mov    $0x6,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <exec>:
SYSCALL(exec)
 253:	b8 07 00 00 00       	mov    $0x7,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <open>:
SYSCALL(open)
 25b:	b8 0f 00 00 00       	mov    $0xf,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <mknod>:
SYSCALL(mknod)
 263:	b8 11 00 00 00       	mov    $0x11,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <unlink>:
SYSCALL(unlink)
 26b:	b8 12 00 00 00       	mov    $0x12,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <fstat>:
SYSCALL(fstat)
 273:	b8 08 00 00 00       	mov    $0x8,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <link>:
SYSCALL(link)
 27b:	b8 13 00 00 00       	mov    $0x13,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <mkdir>:
SYSCALL(mkdir)
 283:	b8 14 00 00 00       	mov    $0x14,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <chdir>:
SYSCALL(chdir)
 28b:	b8 09 00 00 00       	mov    $0x9,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <dup>:
SYSCALL(dup)
 293:	b8 0a 00 00 00       	mov    $0xa,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <getpid>:
SYSCALL(getpid)
 29b:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <getppid>:
SYSCALL(getppid)
 2a3:	b8 17 00 00 00       	mov    $0x17,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <sbrk>:
SYSCALL(sbrk)
 2ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <sleep>:
SYSCALL(sleep)
 2b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <uptime>:
SYSCALL(uptime)
 2bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <myfunction>:
SYSCALL(myfunction)
 2c3:	b8 16 00 00 00       	mov    $0x16,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <yield>:
SYSCALL(yield)
 2cb:	b8 18 00 00 00       	mov    $0x18,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <getlev>:
SYSCALL(getlev)
 2d3:	b8 19 00 00 00       	mov    $0x19,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <set_cpu_share>:
 2db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    
 2e3:	90                   	nop

000002e4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	56                   	push   %esi
 2e9:	53                   	push   %ebx
 2ea:	83 ec 3c             	sub    $0x3c,%esp
 2ed:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2ef:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 2f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2f4:	85 db                	test   %ebx,%ebx
 2f6:	74 04                	je     2fc <printint+0x18>
 2f8:	85 d2                	test   %edx,%edx
 2fa:	78 5d                	js     359 <printint+0x75>
  neg = 0;
 2fc:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 2fe:	31 f6                	xor    %esi,%esi
 300:	eb 04                	jmp    306 <printint+0x22>
 302:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 304:	89 d6                	mov    %edx,%esi
 306:	31 d2                	xor    %edx,%edx
 308:	f7 f1                	div    %ecx
 30a:	8a 92 aa 06 00 00    	mov    0x6aa(%edx),%dl
 310:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 314:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 317:	85 c0                	test   %eax,%eax
 319:	75 e9                	jne    304 <printint+0x20>
  if(neg)
 31b:	85 db                	test   %ebx,%ebx
 31d:	74 08                	je     327 <printint+0x43>
    buf[i++] = '-';
 31f:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 324:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 327:	8d 5a ff             	lea    -0x1(%edx),%ebx
 32a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 334:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 337:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33e:	00 
 33f:	89 74 24 04          	mov    %esi,0x4(%esp)
 343:	89 3c 24             	mov    %edi,(%esp)
 346:	e8 f0 fe ff ff       	call   23b <write>
  while(--i >= 0)
 34b:	4b                   	dec    %ebx
 34c:	83 fb ff             	cmp    $0xffffffff,%ebx
 34f:	75 df                	jne    330 <printint+0x4c>
    putc(fd, buf[i]);
}
 351:	83 c4 3c             	add    $0x3c,%esp
 354:	5b                   	pop    %ebx
 355:	5e                   	pop    %esi
 356:	5f                   	pop    %edi
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    
    x = -xx;
 359:	f7 d8                	neg    %eax
    neg = 1;
 35b:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 360:	eb 9c                	jmp    2fe <printint+0x1a>
 362:	66 90                	xchg   %ax,%ax

00000364 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 3c             	sub    $0x3c,%esp
 36d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 373:	8a 03                	mov    (%ebx),%al
 375:	84 c0                	test   %al,%al
 377:	0f 84 bb 00 00 00    	je     438 <printf+0xd4>
printf(int fd, char *fmt, ...)
 37d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 37e:	8d 55 10             	lea    0x10(%ebp),%edx
 381:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 384:	31 ff                	xor    %edi,%edi
 386:	eb 2f                	jmp    3b7 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 388:	83 f9 25             	cmp    $0x25,%ecx
 38b:	0f 84 af 00 00 00    	je     440 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 391:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 394:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39b:	00 
 39c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 39f:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a3:	89 34 24             	mov    %esi,(%esp)
 3a6:	e8 90 fe ff ff       	call   23b <write>
 3ab:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3ac:	8a 43 ff             	mov    -0x1(%ebx),%al
 3af:	84 c0                	test   %al,%al
 3b1:	0f 84 81 00 00 00    	je     438 <printf+0xd4>
    c = fmt[i] & 0xff;
 3b7:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3ba:	85 ff                	test   %edi,%edi
 3bc:	74 ca                	je     388 <printf+0x24>
      }
    } else if(state == '%'){
 3be:	83 ff 25             	cmp    $0x25,%edi
 3c1:	75 e8                	jne    3ab <printf+0x47>
      if(c == 'd'){
 3c3:	83 f9 64             	cmp    $0x64,%ecx
 3c6:	0f 84 14 01 00 00    	je     4e0 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3cc:	83 f9 78             	cmp    $0x78,%ecx
 3cf:	74 7b                	je     44c <printf+0xe8>
 3d1:	83 f9 70             	cmp    $0x70,%ecx
 3d4:	74 76                	je     44c <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3d6:	83 f9 73             	cmp    $0x73,%ecx
 3d9:	0f 84 91 00 00 00    	je     470 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3df:	83 f9 63             	cmp    $0x63,%ecx
 3e2:	0f 84 cc 00 00 00    	je     4b4 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3e8:	83 f9 25             	cmp    $0x25,%ecx
 3eb:	0f 84 13 01 00 00    	je     504 <printf+0x1a0>
 3f1:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 3f5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3fc:	00 
 3fd:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 400:	89 44 24 04          	mov    %eax,0x4(%esp)
 404:	89 34 24             	mov    %esi,(%esp)
 407:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 40a:	e8 2c fe ff ff       	call   23b <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 40f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 412:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 415:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41c:	00 
 41d:	8d 55 e7             	lea    -0x19(%ebp),%edx
 420:	89 54 24 04          	mov    %edx,0x4(%esp)
 424:	89 34 24             	mov    %esi,(%esp)
 427:	e8 0f fe ff ff       	call   23b <write>
      }
      state = 0;
 42c:	31 ff                	xor    %edi,%edi
 42e:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 42f:	8a 43 ff             	mov    -0x1(%ebx),%al
 432:	84 c0                	test   %al,%al
 434:	75 81                	jne    3b7 <printf+0x53>
 436:	66 90                	xchg   %ax,%ax
    }
  }
}
 438:	83 c4 3c             	add    $0x3c,%esp
 43b:	5b                   	pop    %ebx
 43c:	5e                   	pop    %esi
 43d:	5f                   	pop    %edi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret    
        state = '%';
 440:	bf 25 00 00 00       	mov    $0x25,%edi
 445:	e9 61 ff ff ff       	jmp    3ab <printf+0x47>
 44a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 44c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 453:	b9 10 00 00 00       	mov    $0x10,%ecx
 458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 45b:	8b 10                	mov    (%eax),%edx
 45d:	89 f0                	mov    %esi,%eax
 45f:	e8 80 fe ff ff       	call   2e4 <printint>
        ap++;
 464:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 468:	31 ff                	xor    %edi,%edi
        ap++;
 46a:	e9 3c ff ff ff       	jmp    3ab <printf+0x47>
 46f:	90                   	nop
        s = (char*)*ap;
 470:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 473:	8b 3a                	mov    (%edx),%edi
        ap++;
 475:	83 c2 04             	add    $0x4,%edx
 478:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 47b:	85 ff                	test   %edi,%edi
 47d:	0f 84 a3 00 00 00    	je     526 <printf+0x1c2>
        while(*s != 0){
 483:	8a 07                	mov    (%edi),%al
 485:	84 c0                	test   %al,%al
 487:	74 24                	je     4ad <printf+0x149>
 489:	8d 76 00             	lea    0x0(%esi),%esi
 48c:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 48f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 496:	00 
 497:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 49a:	89 44 24 04          	mov    %eax,0x4(%esp)
 49e:	89 34 24             	mov    %esi,(%esp)
 4a1:	e8 95 fd ff ff       	call   23b <write>
          s++;
 4a6:	47                   	inc    %edi
        while(*s != 0){
 4a7:	8a 07                	mov    (%edi),%al
 4a9:	84 c0                	test   %al,%al
 4ab:	75 df                	jne    48c <printf+0x128>
      state = 0;
 4ad:	31 ff                	xor    %edi,%edi
 4af:	e9 f7 fe ff ff       	jmp    3ab <printf+0x47>
        putc(fd, *ap);
 4b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4b7:	8b 02                	mov    (%edx),%eax
 4b9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c3:	00 
 4c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cb:	89 34 24             	mov    %esi,(%esp)
 4ce:	e8 68 fd ff ff       	call   23b <write>
        ap++;
 4d3:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4d7:	31 ff                	xor    %edi,%edi
 4d9:	e9 cd fe ff ff       	jmp    3ab <printf+0x47>
 4de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 4e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4e7:	b1 0a                	mov    $0xa,%cl
 4e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4ec:	8b 10                	mov    (%eax),%edx
 4ee:	89 f0                	mov    %esi,%eax
 4f0:	e8 ef fd ff ff       	call   2e4 <printint>
        ap++;
 4f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4f9:	66 31 ff             	xor    %di,%di
 4fc:	e9 aa fe ff ff       	jmp    3ab <printf+0x47>
 501:	8d 76 00             	lea    0x0(%esi),%esi
 504:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 508:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 50f:	00 
 510:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	89 34 24             	mov    %esi,(%esp)
 51a:	e8 1c fd ff ff       	call   23b <write>
      state = 0;
 51f:	31 ff                	xor    %edi,%edi
 521:	e9 85 fe ff ff       	jmp    3ab <printf+0x47>
          s = "(null)";
 526:	bf a3 06 00 00       	mov    $0x6a3,%edi
 52b:	e9 53 ff ff ff       	jmp    483 <printf+0x11f>

00000530 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 539:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 53c:	a1 40 09 00 00       	mov    0x940,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 541:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 543:	39 d0                	cmp    %edx,%eax
 545:	72 11                	jb     558 <free+0x28>
 547:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 548:	39 c8                	cmp    %ecx,%eax
 54a:	72 04                	jb     550 <free+0x20>
 54c:	39 ca                	cmp    %ecx,%edx
 54e:	72 10                	jb     560 <free+0x30>
 550:	89 c8                	mov    %ecx,%eax
 552:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 554:	39 d0                	cmp    %edx,%eax
 556:	73 f0                	jae    548 <free+0x18>
 558:	39 ca                	cmp    %ecx,%edx
 55a:	72 04                	jb     560 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55c:	39 c8                	cmp    %ecx,%eax
 55e:	72 f0                	jb     550 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 560:	8b 73 fc             	mov    -0x4(%ebx),%esi
 563:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 566:	39 cf                	cmp    %ecx,%edi
 568:	74 1a                	je     584 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 56a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 56d:	8b 48 04             	mov    0x4(%eax),%ecx
 570:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 573:	39 f2                	cmp    %esi,%edx
 575:	74 24                	je     59b <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 577:	89 10                	mov    %edx,(%eax)
  freep = p;
 579:	a3 40 09 00 00       	mov    %eax,0x940
}
 57e:	5b                   	pop    %ebx
 57f:	5e                   	pop    %esi
 580:	5f                   	pop    %edi
 581:	5d                   	pop    %ebp
 582:	c3                   	ret    
 583:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 584:	03 71 04             	add    0x4(%ecx),%esi
 587:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 58a:	8b 08                	mov    (%eax),%ecx
 58c:	8b 09                	mov    (%ecx),%ecx
 58e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 591:	8b 48 04             	mov    0x4(%eax),%ecx
 594:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 597:	39 f2                	cmp    %esi,%edx
 599:	75 dc                	jne    577 <free+0x47>
    p->s.size += bp->s.size;
 59b:	03 4b fc             	add    -0x4(%ebx),%ecx
 59e:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5a1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5a4:	89 10                	mov    %edx,(%eax)
  freep = p;
 5a6:	a3 40 09 00 00       	mov    %eax,0x940
}
 5ab:	5b                   	pop    %ebx
 5ac:	5e                   	pop    %esi
 5ad:	5f                   	pop    %edi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    

000005b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b9:	8b 75 08             	mov    0x8(%ebp),%esi
 5bc:	83 c6 07             	add    $0x7,%esi
 5bf:	c1 ee 03             	shr    $0x3,%esi
 5c2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5c3:	8b 15 40 09 00 00    	mov    0x940,%edx
 5c9:	85 d2                	test   %edx,%edx
 5cb:	0f 84 8d 00 00 00    	je     65e <malloc+0xae>
 5d1:	8b 02                	mov    (%edx),%eax
 5d3:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5d6:	39 ce                	cmp    %ecx,%esi
 5d8:	76 52                	jbe    62c <malloc+0x7c>
 5da:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 5e1:	eb 0a                	jmp    5ed <malloc+0x3d>
 5e3:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5e4:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5e6:	8b 48 04             	mov    0x4(%eax),%ecx
 5e9:	39 ce                	cmp    %ecx,%esi
 5eb:	76 3f                	jbe    62c <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5ed:	89 c2                	mov    %eax,%edx
 5ef:	3b 05 40 09 00 00    	cmp    0x940,%eax
 5f5:	75 ed                	jne    5e4 <malloc+0x34>
  if(nu < 4096)
 5f7:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 5fd:	76 4d                	jbe    64c <malloc+0x9c>
 5ff:	89 d8                	mov    %ebx,%eax
 601:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 a0 fc ff ff       	call   2ab <sbrk>
  if(p == (char*)-1)
 60b:	83 f8 ff             	cmp    $0xffffffff,%eax
 60e:	74 18                	je     628 <malloc+0x78>
  hp->s.size = nu;
 610:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 613:	83 c0 08             	add    $0x8,%eax
 616:	89 04 24             	mov    %eax,(%esp)
 619:	e8 12 ff ff ff       	call   530 <free>
  return freep;
 61e:	8b 15 40 09 00 00    	mov    0x940,%edx
      if((p = morecore(nunits)) == 0)
 624:	85 d2                	test   %edx,%edx
 626:	75 bc                	jne    5e4 <malloc+0x34>
        return 0;
 628:	31 c0                	xor    %eax,%eax
 62a:	eb 18                	jmp    644 <malloc+0x94>
      if(p->s.size == nunits)
 62c:	39 ce                	cmp    %ecx,%esi
 62e:	74 28                	je     658 <malloc+0xa8>
        p->s.size -= nunits;
 630:	29 f1                	sub    %esi,%ecx
 632:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 635:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 638:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 63b:	89 15 40 09 00 00    	mov    %edx,0x940
      return (void*)(p + 1);
 641:	83 c0 08             	add    $0x8,%eax
  }
}
 644:	83 c4 1c             	add    $0x1c,%esp
 647:	5b                   	pop    %ebx
 648:	5e                   	pop    %esi
 649:	5f                   	pop    %edi
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret    
  if(nu < 4096)
 64c:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 651:	bf 00 10 00 00       	mov    $0x1000,%edi
 656:	eb ab                	jmp    603 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 658:	8b 08                	mov    (%eax),%ecx
 65a:	89 0a                	mov    %ecx,(%edx)
 65c:	eb dd                	jmp    63b <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 65e:	c7 05 40 09 00 00 44 	movl   $0x944,0x940
 665:	09 00 00 
 668:	c7 05 44 09 00 00 44 	movl   $0x944,0x944
 66f:	09 00 00 
    base.s.size = 0;
 672:	c7 05 48 09 00 00 00 	movl   $0x0,0x948
 679:	00 00 00 
 67c:	b8 44 09 00 00       	mov    $0x944,%eax
 681:	e9 54 ff ff ff       	jmp    5da <malloc+0x2a>
