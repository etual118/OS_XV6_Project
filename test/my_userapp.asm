
_my_userapp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char** argv){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    char *buf = "Hello xv6!";
    int ret_val;
    ret_val = myfunction(buf);
   9:	c7 04 24 6a 06 00 00 	movl   $0x66a,(%esp)
  10:	e8 92 02 00 00       	call   2a7 <myfunction>
    printf(1, "Return value : 0x%x\n", ret_val);
  15:	89 44 24 08          	mov    %eax,0x8(%esp)
  19:	c7 44 24 04 75 06 00 	movl   $0x675,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 1b 03 00 00       	call   348 <printf>
    exit();
  2d:	e8 cd 01 00 00       	call   1ff <exit>
  32:	66 90                	xchg   %ax,%ax

00000034 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  34:	55                   	push   %ebp
  35:	89 e5                	mov    %esp,%ebp
  37:	53                   	push   %ebx
  38:	8b 45 08             	mov    0x8(%ebp),%eax
  3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	89 c2                	mov    %eax,%edx
  40:	8a 19                	mov    (%ecx),%bl
  42:	88 1a                	mov    %bl,(%edx)
  44:	42                   	inc    %edx
  45:	41                   	inc    %ecx
  46:	84 db                	test   %bl,%bl
  48:	75 f6                	jne    40 <strcpy+0xc>
    ;
  return os;
}
  4a:	5b                   	pop    %ebx
  4b:	5d                   	pop    %ebp
  4c:	c3                   	ret    
  4d:	8d 76 00             	lea    0x0(%esi),%esi

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 55 08             	mov    0x8(%ebp),%edx
  58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  5b:	0f b6 02             	movzbl (%edx),%eax
  5e:	0f b6 19             	movzbl (%ecx),%ebx
  61:	84 c0                	test   %al,%al
  63:	75 14                	jne    79 <strcmp+0x29>
  65:	eb 1d                	jmp    84 <strcmp+0x34>
  67:	90                   	nop
    p++, q++;
  68:	42                   	inc    %edx
  69:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  6c:	0f b6 02             	movzbl (%edx),%eax
  6f:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  73:	84 c0                	test   %al,%al
  75:	74 0d                	je     84 <strcmp+0x34>
    p++, q++;
  77:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  79:	38 d8                	cmp    %bl,%al
  7b:	74 eb                	je     68 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  7d:	29 d8                	sub    %ebx,%eax
}
  7f:	5b                   	pop    %ebx
  80:	5e                   	pop    %esi
  81:	5d                   	pop    %ebp
  82:	c3                   	ret    
  83:	90                   	nop
  while(*p && *p == *q)
  84:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  86:	29 d8                	sub    %ebx,%eax
}
  88:	5b                   	pop    %ebx
  89:	5e                   	pop    %esi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strlen>:

uint
strlen(char *s)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  92:	80 39 00             	cmpb   $0x0,(%ecx)
  95:	74 10                	je     a7 <strlen+0x1b>
  97:	31 d2                	xor    %edx,%edx
  99:	8d 76 00             	lea    0x0(%esi),%esi
  9c:	42                   	inc    %edx
  9d:	89 d0                	mov    %edx,%eax
  9f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  a3:	75 f7                	jne    9c <strlen+0x10>
    ;
  return n;
}
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    
  for(n = 0; s[n]; n++)
  a7:	31 c0                	xor    %eax,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    
  ab:	90                   	nop

000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b3:	89 d7                	mov    %edx,%edi
  b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	fc                   	cld    
  bc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  be:	89 d0                	mov    %edx,%eax
  c0:	5f                   	pop    %edi
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    
  c3:	90                   	nop

000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  cd:	8a 10                	mov    (%eax),%dl
  cf:	84 d2                	test   %dl,%dl
  d1:	75 0c                	jne    df <strchr+0x1b>
  d3:	eb 13                	jmp    e8 <strchr+0x24>
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  d8:	40                   	inc    %eax
  d9:	8a 10                	mov    (%eax),%dl
  db:	84 d2                	test   %dl,%dl
  dd:	74 09                	je     e8 <strchr+0x24>
    if(*s == c)
  df:	38 ca                	cmp    %cl,%dl
  e1:	75 f5                	jne    d8 <strchr+0x14>
      return (char*)s;
  return 0;
}
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret    
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  e8:	31 c0                	xor    %eax,%eax
}
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    

000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	53                   	push   %ebx
  f2:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
  f7:	8d 7d e7             	lea    -0x19(%ebp),%edi
  fa:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
  fc:	8d 73 01             	lea    0x1(%ebx),%esi
  ff:	3b 75 0c             	cmp    0xc(%ebp),%esi
 102:	7d 40                	jge    144 <gets+0x58>
    cc = read(0, &c, 1);
 104:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 10b:	00 
 10c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 117:	e8 fb 00 00 00       	call   217 <read>
    if(cc < 1)
 11c:	85 c0                	test   %eax,%eax
 11e:	7e 24                	jle    144 <gets+0x58>
      break;
    buf[i++] = c;
 120:	8a 45 e7             	mov    -0x19(%ebp),%al
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 12a:	3c 0a                	cmp    $0xa,%al
 12c:	74 06                	je     134 <gets+0x48>
 12e:	89 f3                	mov    %esi,%ebx
 130:	3c 0d                	cmp    $0xd,%al
 132:	75 c8                	jne    fc <gets+0x10>
      break;
  }
  buf[i] = '\0';
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 13b:	83 c4 2c             	add    $0x2c,%esp
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5f                   	pop    %edi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	90                   	nop
    if(cc < 1)
 144:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 14d:	83 c4 2c             	add    $0x2c,%esp
 150:	5b                   	pop    %ebx
 151:	5e                   	pop    %esi
 152:	5f                   	pop    %edi
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    
 155:	8d 76 00             	lea    0x0(%esi),%esi

00000158 <stat>:

int
stat(char *n, struct stat *st)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	56                   	push   %esi
 15c:	53                   	push   %ebx
 15d:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 160:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 167:	00 
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 cc 00 00 00       	call   23f <open>
 173:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 175:	85 c0                	test   %eax,%eax
 177:	78 23                	js     19c <stat+0x44>
    return -1;
  r = fstat(fd, st);
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	89 44 24 04          	mov    %eax,0x4(%esp)
 180:	89 1c 24             	mov    %ebx,(%esp)
 183:	e8 cf 00 00 00       	call   257 <fstat>
 188:	89 c6                	mov    %eax,%esi
  close(fd);
 18a:	89 1c 24             	mov    %ebx,(%esp)
 18d:	e8 95 00 00 00       	call   227 <close>
  return r;
}
 192:	89 f0                	mov    %esi,%eax
 194:	83 c4 10             	add    $0x10,%esp
 197:	5b                   	pop    %ebx
 198:	5e                   	pop    %esi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
 19b:	90                   	nop
    return -1;
 19c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a1:	eb ef                	jmp    192 <stat+0x3a>
 1a3:	90                   	nop

000001a4 <atoi>:

int
atoi(const char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	53                   	push   %ebx
 1a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ab:	0f be 11             	movsbl (%ecx),%edx
 1ae:	8d 42 d0             	lea    -0x30(%edx),%eax
 1b1:	3c 09                	cmp    $0x9,%al
 1b3:	b8 00 00 00 00       	mov    $0x0,%eax
 1b8:	77 15                	ja     1cf <atoi+0x2b>
 1ba:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1c3:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 1c4:	0f be 11             	movsbl (%ecx),%edx
 1c7:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ca:	80 fb 09             	cmp    $0x9,%bl
 1cd:	76 ed                	jbe    1bc <atoi+0x18>
  return n;
}
 1cf:	5b                   	pop    %ebx
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    
 1d2:	66 90                	xchg   %ax,%ax

000001d4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	56                   	push   %esi
 1d8:	53                   	push   %ebx
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1df:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 1e2:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1e4:	85 f6                	test   %esi,%esi
 1e6:	7e 0b                	jle    1f3 <memmove+0x1f>
    *dst++ = *src++;
 1e8:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 1eb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1ee:	42                   	inc    %edx
  while(n-- > 0)
 1ef:	39 f2                	cmp    %esi,%edx
 1f1:	75 f5                	jne    1e8 <memmove+0x14>
  return vdst;
}
 1f3:	5b                   	pop    %ebx
 1f4:	5e                   	pop    %esi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1f7:	b8 01 00 00 00       	mov    $0x1,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <exit>:
SYSCALL(exit)
 1ff:	b8 02 00 00 00       	mov    $0x2,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <wait>:
SYSCALL(wait)
 207:	b8 03 00 00 00       	mov    $0x3,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <pipe>:
SYSCALL(pipe)
 20f:	b8 04 00 00 00       	mov    $0x4,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <read>:
SYSCALL(read)
 217:	b8 05 00 00 00       	mov    $0x5,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <write>:
SYSCALL(write)
 21f:	b8 10 00 00 00       	mov    $0x10,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <close>:
SYSCALL(close)
 227:	b8 15 00 00 00       	mov    $0x15,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <kill>:
SYSCALL(kill)
 22f:	b8 06 00 00 00       	mov    $0x6,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <exec>:
SYSCALL(exec)
 237:	b8 07 00 00 00       	mov    $0x7,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <open>:
SYSCALL(open)
 23f:	b8 0f 00 00 00       	mov    $0xf,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <mknod>:
SYSCALL(mknod)
 247:	b8 11 00 00 00       	mov    $0x11,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <unlink>:
SYSCALL(unlink)
 24f:	b8 12 00 00 00       	mov    $0x12,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <fstat>:
SYSCALL(fstat)
 257:	b8 08 00 00 00       	mov    $0x8,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <link>:
SYSCALL(link)
 25f:	b8 13 00 00 00       	mov    $0x13,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <mkdir>:
SYSCALL(mkdir)
 267:	b8 14 00 00 00       	mov    $0x14,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <chdir>:
SYSCALL(chdir)
 26f:	b8 09 00 00 00       	mov    $0x9,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <dup>:
SYSCALL(dup)
 277:	b8 0a 00 00 00       	mov    $0xa,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <getpid>:
SYSCALL(getpid)
 27f:	b8 0b 00 00 00       	mov    $0xb,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <getppid>:
SYSCALL(getppid)
 287:	b8 17 00 00 00       	mov    $0x17,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <sbrk>:
SYSCALL(sbrk)
 28f:	b8 0c 00 00 00       	mov    $0xc,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <sleep>:
SYSCALL(sleep)
 297:	b8 0d 00 00 00       	mov    $0xd,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <uptime>:
SYSCALL(uptime)
 29f:	b8 0e 00 00 00       	mov    $0xe,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <myfunction>:
SYSCALL(myfunction)
 2a7:	b8 16 00 00 00       	mov    $0x16,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <yield>:
SYSCALL(yield)
 2af:	b8 18 00 00 00       	mov    $0x18,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <getlev>:
SYSCALL(getlev)
 2b7:	b8 19 00 00 00       	mov    $0x19,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <set_cpu_share>:
 2bf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    
 2c7:	90                   	nop

000002c8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	53                   	push   %ebx
 2ce:	83 ec 3c             	sub    $0x3c,%esp
 2d1:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2d3:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 2d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2d8:	85 db                	test   %ebx,%ebx
 2da:	74 04                	je     2e0 <printint+0x18>
 2dc:	85 d2                	test   %edx,%edx
 2de:	78 5d                	js     33d <printint+0x75>
  neg = 0;
 2e0:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 2e2:	31 f6                	xor    %esi,%esi
 2e4:	eb 04                	jmp    2ea <printint+0x22>
 2e6:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 2e8:	89 d6                	mov    %edx,%esi
 2ea:	31 d2                	xor    %edx,%edx
 2ec:	f7 f1                	div    %ecx
 2ee:	8a 92 91 06 00 00    	mov    0x691(%edx),%dl
 2f4:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 2f8:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 2fb:	85 c0                	test   %eax,%eax
 2fd:	75 e9                	jne    2e8 <printint+0x20>
  if(neg)
 2ff:	85 db                	test   %ebx,%ebx
 301:	74 08                	je     30b <printint+0x43>
    buf[i++] = '-';
 303:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 308:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 30b:	8d 5a ff             	lea    -0x1(%edx),%ebx
 30e:	8d 75 d7             	lea    -0x29(%ebp),%esi
 311:	8d 76 00             	lea    0x0(%esi),%esi
 314:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 318:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 31b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 322:	00 
 323:	89 74 24 04          	mov    %esi,0x4(%esp)
 327:	89 3c 24             	mov    %edi,(%esp)
 32a:	e8 f0 fe ff ff       	call   21f <write>
  while(--i >= 0)
 32f:	4b                   	dec    %ebx
 330:	83 fb ff             	cmp    $0xffffffff,%ebx
 333:	75 df                	jne    314 <printint+0x4c>
    putc(fd, buf[i]);
}
 335:	83 c4 3c             	add    $0x3c,%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
    x = -xx;
 33d:	f7 d8                	neg    %eax
    neg = 1;
 33f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 344:	eb 9c                	jmp    2e2 <printint+0x1a>
 346:	66 90                	xchg   %ax,%ax

00000348 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
 34e:	83 ec 3c             	sub    $0x3c,%esp
 351:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 354:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 357:	8a 03                	mov    (%ebx),%al
 359:	84 c0                	test   %al,%al
 35b:	0f 84 bb 00 00 00    	je     41c <printf+0xd4>
printf(int fd, char *fmt, ...)
 361:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 362:	8d 55 10             	lea    0x10(%ebp),%edx
 365:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 368:	31 ff                	xor    %edi,%edi
 36a:	eb 2f                	jmp    39b <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 36c:	83 f9 25             	cmp    $0x25,%ecx
 36f:	0f 84 af 00 00 00    	je     424 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 375:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 378:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 37f:	00 
 380:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 383:	89 44 24 04          	mov    %eax,0x4(%esp)
 387:	89 34 24             	mov    %esi,(%esp)
 38a:	e8 90 fe ff ff       	call   21f <write>
 38f:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 390:	8a 43 ff             	mov    -0x1(%ebx),%al
 393:	84 c0                	test   %al,%al
 395:	0f 84 81 00 00 00    	je     41c <printf+0xd4>
    c = fmt[i] & 0xff;
 39b:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 39e:	85 ff                	test   %edi,%edi
 3a0:	74 ca                	je     36c <printf+0x24>
      }
    } else if(state == '%'){
 3a2:	83 ff 25             	cmp    $0x25,%edi
 3a5:	75 e8                	jne    38f <printf+0x47>
      if(c == 'd'){
 3a7:	83 f9 64             	cmp    $0x64,%ecx
 3aa:	0f 84 14 01 00 00    	je     4c4 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3b0:	83 f9 78             	cmp    $0x78,%ecx
 3b3:	74 7b                	je     430 <printf+0xe8>
 3b5:	83 f9 70             	cmp    $0x70,%ecx
 3b8:	74 76                	je     430 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3ba:	83 f9 73             	cmp    $0x73,%ecx
 3bd:	0f 84 91 00 00 00    	je     454 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3c3:	83 f9 63             	cmp    $0x63,%ecx
 3c6:	0f 84 cc 00 00 00    	je     498 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3cc:	83 f9 25             	cmp    $0x25,%ecx
 3cf:	0f 84 13 01 00 00    	je     4e8 <printf+0x1a0>
 3d5:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 3d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e0:	00 
 3e1:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 3e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e8:	89 34 24             	mov    %esi,(%esp)
 3eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 3ee:	e8 2c fe ff ff       	call   21f <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 3f3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 3f6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 3f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 400:	00 
 401:	8d 55 e7             	lea    -0x19(%ebp),%edx
 404:	89 54 24 04          	mov    %edx,0x4(%esp)
 408:	89 34 24             	mov    %esi,(%esp)
 40b:	e8 0f fe ff ff       	call   21f <write>
      }
      state = 0;
 410:	31 ff                	xor    %edi,%edi
 412:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 413:	8a 43 ff             	mov    -0x1(%ebx),%al
 416:	84 c0                	test   %al,%al
 418:	75 81                	jne    39b <printf+0x53>
 41a:	66 90                	xchg   %ax,%ax
    }
  }
}
 41c:	83 c4 3c             	add    $0x3c,%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
        state = '%';
 424:	bf 25 00 00 00       	mov    $0x25,%edi
 429:	e9 61 ff ff ff       	jmp    38f <printf+0x47>
 42e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 430:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 437:	b9 10 00 00 00       	mov    $0x10,%ecx
 43c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 43f:	8b 10                	mov    (%eax),%edx
 441:	89 f0                	mov    %esi,%eax
 443:	e8 80 fe ff ff       	call   2c8 <printint>
        ap++;
 448:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 44c:	31 ff                	xor    %edi,%edi
        ap++;
 44e:	e9 3c ff ff ff       	jmp    38f <printf+0x47>
 453:	90                   	nop
        s = (char*)*ap;
 454:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 457:	8b 3a                	mov    (%edx),%edi
        ap++;
 459:	83 c2 04             	add    $0x4,%edx
 45c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 45f:	85 ff                	test   %edi,%edi
 461:	0f 84 a3 00 00 00    	je     50a <printf+0x1c2>
        while(*s != 0){
 467:	8a 07                	mov    (%edi),%al
 469:	84 c0                	test   %al,%al
 46b:	74 24                	je     491 <printf+0x149>
 46d:	8d 76 00             	lea    0x0(%esi),%esi
 470:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 473:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47a:	00 
 47b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 47e:	89 44 24 04          	mov    %eax,0x4(%esp)
 482:	89 34 24             	mov    %esi,(%esp)
 485:	e8 95 fd ff ff       	call   21f <write>
          s++;
 48a:	47                   	inc    %edi
        while(*s != 0){
 48b:	8a 07                	mov    (%edi),%al
 48d:	84 c0                	test   %al,%al
 48f:	75 df                	jne    470 <printf+0x128>
      state = 0;
 491:	31 ff                	xor    %edi,%edi
 493:	e9 f7 fe ff ff       	jmp    38f <printf+0x47>
        putc(fd, *ap);
 498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 49b:	8b 02                	mov    (%edx),%eax
 49d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a7:	00 
 4a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 4af:	89 34 24             	mov    %esi,(%esp)
 4b2:	e8 68 fd ff ff       	call   21f <write>
        ap++;
 4b7:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4bb:	31 ff                	xor    %edi,%edi
 4bd:	e9 cd fe ff ff       	jmp    38f <printf+0x47>
 4c2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 4c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4cb:	b1 0a                	mov    $0xa,%cl
 4cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4d0:	8b 10                	mov    (%eax),%edx
 4d2:	89 f0                	mov    %esi,%eax
 4d4:	e8 ef fd ff ff       	call   2c8 <printint>
        ap++;
 4d9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4dd:	66 31 ff             	xor    %di,%di
 4e0:	e9 aa fe ff ff       	jmp    38f <printf+0x47>
 4e5:	8d 76 00             	lea    0x0(%esi),%esi
 4e8:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 4ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f3:	00 
 4f4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fb:	89 34 24             	mov    %esi,(%esp)
 4fe:	e8 1c fd ff ff       	call   21f <write>
      state = 0;
 503:	31 ff                	xor    %edi,%edi
 505:	e9 85 fe ff ff       	jmp    38f <printf+0x47>
          s = "(null)";
 50a:	bf 8a 06 00 00       	mov    $0x68a,%edi
 50f:	e9 53 ff ff ff       	jmp    467 <printf+0x11f>

00000514 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	57                   	push   %edi
 518:	56                   	push   %esi
 519:	53                   	push   %ebx
 51a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 51d:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 520:	a1 24 09 00 00       	mov    0x924,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 525:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 527:	39 d0                	cmp    %edx,%eax
 529:	72 11                	jb     53c <free+0x28>
 52b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52c:	39 c8                	cmp    %ecx,%eax
 52e:	72 04                	jb     534 <free+0x20>
 530:	39 ca                	cmp    %ecx,%edx
 532:	72 10                	jb     544 <free+0x30>
 534:	89 c8                	mov    %ecx,%eax
 536:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 538:	39 d0                	cmp    %edx,%eax
 53a:	73 f0                	jae    52c <free+0x18>
 53c:	39 ca                	cmp    %ecx,%edx
 53e:	72 04                	jb     544 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 540:	39 c8                	cmp    %ecx,%eax
 542:	72 f0                	jb     534 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 544:	8b 73 fc             	mov    -0x4(%ebx),%esi
 547:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 54a:	39 cf                	cmp    %ecx,%edi
 54c:	74 1a                	je     568 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 54e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 551:	8b 48 04             	mov    0x4(%eax),%ecx
 554:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 557:	39 f2                	cmp    %esi,%edx
 559:	74 24                	je     57f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 55b:	89 10                	mov    %edx,(%eax)
  freep = p;
 55d:	a3 24 09 00 00       	mov    %eax,0x924
}
 562:	5b                   	pop    %ebx
 563:	5e                   	pop    %esi
 564:	5f                   	pop    %edi
 565:	5d                   	pop    %ebp
 566:	c3                   	ret    
 567:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 568:	03 71 04             	add    0x4(%ecx),%esi
 56b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 56e:	8b 08                	mov    (%eax),%ecx
 570:	8b 09                	mov    (%ecx),%ecx
 572:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 575:	8b 48 04             	mov    0x4(%eax),%ecx
 578:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 57b:	39 f2                	cmp    %esi,%edx
 57d:	75 dc                	jne    55b <free+0x47>
    p->s.size += bp->s.size;
 57f:	03 4b fc             	add    -0x4(%ebx),%ecx
 582:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 585:	8b 53 f8             	mov    -0x8(%ebx),%edx
 588:	89 10                	mov    %edx,(%eax)
  freep = p;
 58a:	a3 24 09 00 00       	mov    %eax,0x924
}
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    

00000594 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 59d:	8b 75 08             	mov    0x8(%ebp),%esi
 5a0:	83 c6 07             	add    $0x7,%esi
 5a3:	c1 ee 03             	shr    $0x3,%esi
 5a6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5a7:	8b 15 24 09 00 00    	mov    0x924,%edx
 5ad:	85 d2                	test   %edx,%edx
 5af:	0f 84 8d 00 00 00    	je     642 <malloc+0xae>
 5b5:	8b 02                	mov    (%edx),%eax
 5b7:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5ba:	39 ce                	cmp    %ecx,%esi
 5bc:	76 52                	jbe    610 <malloc+0x7c>
 5be:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 5c5:	eb 0a                	jmp    5d1 <malloc+0x3d>
 5c7:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ca:	8b 48 04             	mov    0x4(%eax),%ecx
 5cd:	39 ce                	cmp    %ecx,%esi
 5cf:	76 3f                	jbe    610 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5d1:	89 c2                	mov    %eax,%edx
 5d3:	3b 05 24 09 00 00    	cmp    0x924,%eax
 5d9:	75 ed                	jne    5c8 <malloc+0x34>
  if(nu < 4096)
 5db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 5e1:	76 4d                	jbe    630 <malloc+0x9c>
 5e3:	89 d8                	mov    %ebx,%eax
 5e5:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 a0 fc ff ff       	call   28f <sbrk>
  if(p == (char*)-1)
 5ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 5f2:	74 18                	je     60c <malloc+0x78>
  hp->s.size = nu;
 5f4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 5f7:	83 c0 08             	add    $0x8,%eax
 5fa:	89 04 24             	mov    %eax,(%esp)
 5fd:	e8 12 ff ff ff       	call   514 <free>
  return freep;
 602:	8b 15 24 09 00 00    	mov    0x924,%edx
      if((p = morecore(nunits)) == 0)
 608:	85 d2                	test   %edx,%edx
 60a:	75 bc                	jne    5c8 <malloc+0x34>
        return 0;
 60c:	31 c0                	xor    %eax,%eax
 60e:	eb 18                	jmp    628 <malloc+0x94>
      if(p->s.size == nunits)
 610:	39 ce                	cmp    %ecx,%esi
 612:	74 28                	je     63c <malloc+0xa8>
        p->s.size -= nunits;
 614:	29 f1                	sub    %esi,%ecx
 616:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 619:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 61c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 61f:	89 15 24 09 00 00    	mov    %edx,0x924
      return (void*)(p + 1);
 625:	83 c0 08             	add    $0x8,%eax
  }
}
 628:	83 c4 1c             	add    $0x1c,%esp
 62b:	5b                   	pop    %ebx
 62c:	5e                   	pop    %esi
 62d:	5f                   	pop    %edi
 62e:	5d                   	pop    %ebp
 62f:	c3                   	ret    
  if(nu < 4096)
 630:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 635:	bf 00 10 00 00       	mov    $0x1000,%edi
 63a:	eb ab                	jmp    5e7 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 63c:	8b 08                	mov    (%eax),%ecx
 63e:	89 0a                	mov    %ecx,(%edx)
 640:	eb dd                	jmp    61f <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 642:	c7 05 24 09 00 00 28 	movl   $0x928,0x924
 649:	09 00 00 
 64c:	c7 05 28 09 00 00 28 	movl   $0x928,0x928
 653:	09 00 00 
    base.s.size = 0;
 656:	c7 05 2c 09 00 00 00 	movl   $0x0,0x92c
 65d:	00 00 00 
 660:	b8 28 09 00 00       	mov    $0x928,%eax
 665:	e9 54 ff ff ff       	jmp    5be <malloc+0x2a>
