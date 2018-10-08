
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 d9 01 00 00       	call   1e7 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 69 02 00 00       	call   287 <sleep>
  exit();
  1e:	e8 cc 01 00 00       	call   1ef <exit>
  23:	90                   	nop

00000024 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	53                   	push   %ebx
  28:	8b 45 08             	mov    0x8(%ebp),%eax
  2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	89 c2                	mov    %eax,%edx
  30:	8a 19                	mov    (%ecx),%bl
  32:	88 1a                	mov    %bl,(%edx)
  34:	42                   	inc    %edx
  35:	41                   	inc    %ecx
  36:	84 db                	test   %bl,%bl
  38:	75 f6                	jne    30 <strcpy+0xc>
    ;
  return os;
}
  3a:	5b                   	pop    %ebx
  3b:	5d                   	pop    %ebp
  3c:	c3                   	ret    
  3d:	8d 76 00             	lea    0x0(%esi),%esi

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
  45:	8b 55 08             	mov    0x8(%ebp),%edx
  48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  4b:	0f b6 02             	movzbl (%edx),%eax
  4e:	0f b6 19             	movzbl (%ecx),%ebx
  51:	84 c0                	test   %al,%al
  53:	75 14                	jne    69 <strcmp+0x29>
  55:	eb 1d                	jmp    74 <strcmp+0x34>
  57:	90                   	nop
    p++, q++;
  58:	42                   	inc    %edx
  59:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  5c:	0f b6 02             	movzbl (%edx),%eax
  5f:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  63:	84 c0                	test   %al,%al
  65:	74 0d                	je     74 <strcmp+0x34>
    p++, q++;
  67:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  69:	38 d8                	cmp    %bl,%al
  6b:	74 eb                	je     58 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  6d:	29 d8                	sub    %ebx,%eax
}
  6f:	5b                   	pop    %ebx
  70:	5e                   	pop    %esi
  71:	5d                   	pop    %ebp
  72:	c3                   	ret    
  73:	90                   	nop
  while(*p && *p == *q)
  74:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  76:	29 d8                	sub    %ebx,%eax
}
  78:	5b                   	pop    %ebx
  79:	5e                   	pop    %esi
  7a:	5d                   	pop    %ebp
  7b:	c3                   	ret    

0000007c <strlen>:

uint
strlen(char *s)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  82:	80 39 00             	cmpb   $0x0,(%ecx)
  85:	74 10                	je     97 <strlen+0x1b>
  87:	31 d2                	xor    %edx,%edx
  89:	8d 76 00             	lea    0x0(%esi),%esi
  8c:	42                   	inc    %edx
  8d:	89 d0                	mov    %edx,%eax
  8f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  93:	75 f7                	jne    8c <strlen+0x10>
    ;
  return n;
}
  95:	5d                   	pop    %ebp
  96:	c3                   	ret    
  for(n = 0; s[n]; n++)
  97:	31 c0                	xor    %eax,%eax
}
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    
  9b:	90                   	nop

0000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	57                   	push   %edi
  a0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a3:	89 d7                	mov    %edx,%edi
  a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	fc                   	cld    
  ac:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ae:	89 d0                	mov    %edx,%eax
  b0:	5f                   	pop    %edi
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    
  b3:	90                   	nop

000000b4 <strchr>:

char*
strchr(const char *s, char c)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	8b 45 08             	mov    0x8(%ebp),%eax
  ba:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  bd:	8a 10                	mov    (%eax),%dl
  bf:	84 d2                	test   %dl,%dl
  c1:	75 0c                	jne    cf <strchr+0x1b>
  c3:	eb 13                	jmp    d8 <strchr+0x24>
  c5:	8d 76 00             	lea    0x0(%esi),%esi
  c8:	40                   	inc    %eax
  c9:	8a 10                	mov    (%eax),%dl
  cb:	84 d2                	test   %dl,%dl
  cd:	74 09                	je     d8 <strchr+0x24>
    if(*s == c)
  cf:	38 ca                	cmp    %cl,%dl
  d1:	75 f5                	jne    c8 <strchr+0x14>
      return (char*)s;
  return 0;
}
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  d8:	31 c0                	xor    %eax,%eax
}
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    

000000dc <gets>:

char*
gets(char *buf, int max)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	57                   	push   %edi
  e0:	56                   	push   %esi
  e1:	53                   	push   %ebx
  e2:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
  e7:	8d 7d e7             	lea    -0x19(%ebp),%edi
  ea:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
  ec:	8d 73 01             	lea    0x1(%ebx),%esi
  ef:	3b 75 0c             	cmp    0xc(%ebp),%esi
  f2:	7d 40                	jge    134 <gets+0x58>
    cc = read(0, &c, 1);
  f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  fb:	00 
  fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
 100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 107:	e8 fb 00 00 00       	call   207 <read>
    if(cc < 1)
 10c:	85 c0                	test   %eax,%eax
 10e:	7e 24                	jle    134 <gets+0x58>
      break;
    buf[i++] = c;
 110:	8a 45 e7             	mov    -0x19(%ebp),%al
 113:	8b 55 08             	mov    0x8(%ebp),%edx
 116:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 11a:	3c 0a                	cmp    $0xa,%al
 11c:	74 06                	je     124 <gets+0x48>
 11e:	89 f3                	mov    %esi,%ebx
 120:	3c 0d                	cmp    $0xd,%al
 122:	75 c8                	jne    ec <gets+0x10>
      break;
  }
  buf[i] = '\0';
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 12b:	83 c4 2c             	add    $0x2c,%esp
 12e:	5b                   	pop    %ebx
 12f:	5e                   	pop    %esi
 130:	5f                   	pop    %edi
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	90                   	nop
    if(cc < 1)
 134:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 13d:	83 c4 2c             	add    $0x2c,%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 76 00             	lea    0x0(%esi),%esi

00000148 <stat>:

int
stat(char *n, struct stat *st)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	56                   	push   %esi
 14c:	53                   	push   %ebx
 14d:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 150:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 157:	00 
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	89 04 24             	mov    %eax,(%esp)
 15e:	e8 cc 00 00 00       	call   22f <open>
 163:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 165:	85 c0                	test   %eax,%eax
 167:	78 23                	js     18c <stat+0x44>
    return -1;
  r = fstat(fd, st);
 169:	8b 45 0c             	mov    0xc(%ebp),%eax
 16c:	89 44 24 04          	mov    %eax,0x4(%esp)
 170:	89 1c 24             	mov    %ebx,(%esp)
 173:	e8 cf 00 00 00       	call   247 <fstat>
 178:	89 c6                	mov    %eax,%esi
  close(fd);
 17a:	89 1c 24             	mov    %ebx,(%esp)
 17d:	e8 95 00 00 00       	call   217 <close>
  return r;
}
 182:	89 f0                	mov    %esi,%eax
 184:	83 c4 10             	add    $0x10,%esp
 187:	5b                   	pop    %ebx
 188:	5e                   	pop    %esi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop
    return -1;
 18c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 191:	eb ef                	jmp    182 <stat+0x3a>
 193:	90                   	nop

00000194 <atoi>:

int
atoi(const char *s)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	53                   	push   %ebx
 198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19b:	0f be 11             	movsbl (%ecx),%edx
 19e:	8d 42 d0             	lea    -0x30(%edx),%eax
 1a1:	3c 09                	cmp    $0x9,%al
 1a3:	b8 00 00 00 00       	mov    $0x0,%eax
 1a8:	77 15                	ja     1bf <atoi+0x2b>
 1aa:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1b3:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 1b4:	0f be 11             	movsbl (%ecx),%edx
 1b7:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ba:	80 fb 09             	cmp    $0x9,%bl
 1bd:	76 ed                	jbe    1ac <atoi+0x18>
  return n;
}
 1bf:	5b                   	pop    %ebx
 1c0:	5d                   	pop    %ebp
 1c1:	c3                   	ret    
 1c2:	66 90                	xchg   %ax,%ax

000001c4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	56                   	push   %esi
 1c8:	53                   	push   %ebx
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1cf:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 1d2:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1d4:	85 f6                	test   %esi,%esi
 1d6:	7e 0b                	jle    1e3 <memmove+0x1f>
    *dst++ = *src++;
 1d8:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 1db:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1de:	42                   	inc    %edx
  while(n-- > 0)
 1df:	39 f2                	cmp    %esi,%edx
 1e1:	75 f5                	jne    1d8 <memmove+0x14>
  return vdst;
}
 1e3:	5b                   	pop    %ebx
 1e4:	5e                   	pop    %esi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e7:	b8 01 00 00 00       	mov    $0x1,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <exit>:
SYSCALL(exit)
 1ef:	b8 02 00 00 00       	mov    $0x2,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <wait>:
SYSCALL(wait)
 1f7:	b8 03 00 00 00       	mov    $0x3,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <pipe>:
SYSCALL(pipe)
 1ff:	b8 04 00 00 00       	mov    $0x4,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <read>:
SYSCALL(read)
 207:	b8 05 00 00 00       	mov    $0x5,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <write>:
SYSCALL(write)
 20f:	b8 10 00 00 00       	mov    $0x10,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <close>:
SYSCALL(close)
 217:	b8 15 00 00 00       	mov    $0x15,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <kill>:
SYSCALL(kill)
 21f:	b8 06 00 00 00       	mov    $0x6,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <exec>:
SYSCALL(exec)
 227:	b8 07 00 00 00       	mov    $0x7,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <open>:
SYSCALL(open)
 22f:	b8 0f 00 00 00       	mov    $0xf,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <mknod>:
SYSCALL(mknod)
 237:	b8 11 00 00 00       	mov    $0x11,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <unlink>:
SYSCALL(unlink)
 23f:	b8 12 00 00 00       	mov    $0x12,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <fstat>:
SYSCALL(fstat)
 247:	b8 08 00 00 00       	mov    $0x8,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <link>:
SYSCALL(link)
 24f:	b8 13 00 00 00       	mov    $0x13,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <mkdir>:
SYSCALL(mkdir)
 257:	b8 14 00 00 00       	mov    $0x14,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <chdir>:
SYSCALL(chdir)
 25f:	b8 09 00 00 00       	mov    $0x9,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <dup>:
SYSCALL(dup)
 267:	b8 0a 00 00 00       	mov    $0xa,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <getpid>:
SYSCALL(getpid)
 26f:	b8 0b 00 00 00       	mov    $0xb,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <getppid>:
SYSCALL(getppid)
 277:	b8 17 00 00 00       	mov    $0x17,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <sbrk>:
SYSCALL(sbrk)
 27f:	b8 0c 00 00 00       	mov    $0xc,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <sleep>:
SYSCALL(sleep)
 287:	b8 0d 00 00 00       	mov    $0xd,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <uptime>:
SYSCALL(uptime)
 28f:	b8 0e 00 00 00       	mov    $0xe,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <myfunction>:
SYSCALL(myfunction)
 297:	b8 16 00 00 00       	mov    $0x16,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <yield>:
SYSCALL(yield)
 29f:	b8 18 00 00 00       	mov    $0x18,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <getlev>:
SYSCALL(getlev)
 2a7:	b8 19 00 00 00       	mov    $0x19,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <set_cpu_share>:
 2af:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    
 2b7:	90                   	nop

000002b8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	57                   	push   %edi
 2bc:	56                   	push   %esi
 2bd:	53                   	push   %ebx
 2be:	83 ec 3c             	sub    $0x3c,%esp
 2c1:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2c3:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 2c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2c8:	85 db                	test   %ebx,%ebx
 2ca:	74 04                	je     2d0 <printint+0x18>
 2cc:	85 d2                	test   %edx,%edx
 2ce:	78 5d                	js     32d <printint+0x75>
  neg = 0;
 2d0:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 2d2:	31 f6                	xor    %esi,%esi
 2d4:	eb 04                	jmp    2da <printint+0x22>
 2d6:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 2d8:	89 d6                	mov    %edx,%esi
 2da:	31 d2                	xor    %edx,%edx
 2dc:	f7 f1                	div    %ecx
 2de:	8a 92 61 06 00 00    	mov    0x661(%edx),%dl
 2e4:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 2e8:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 2eb:	85 c0                	test   %eax,%eax
 2ed:	75 e9                	jne    2d8 <printint+0x20>
  if(neg)
 2ef:	85 db                	test   %ebx,%ebx
 2f1:	74 08                	je     2fb <printint+0x43>
    buf[i++] = '-';
 2f3:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 2f8:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 2fb:	8d 5a ff             	lea    -0x1(%edx),%ebx
 2fe:	8d 75 d7             	lea    -0x29(%ebp),%esi
 301:	8d 76 00             	lea    0x0(%esi),%esi
 304:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 308:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 30b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 312:	00 
 313:	89 74 24 04          	mov    %esi,0x4(%esp)
 317:	89 3c 24             	mov    %edi,(%esp)
 31a:	e8 f0 fe ff ff       	call   20f <write>
  while(--i >= 0)
 31f:	4b                   	dec    %ebx
 320:	83 fb ff             	cmp    $0xffffffff,%ebx
 323:	75 df                	jne    304 <printint+0x4c>
    putc(fd, buf[i]);
}
 325:	83 c4 3c             	add    $0x3c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
    x = -xx;
 32d:	f7 d8                	neg    %eax
    neg = 1;
 32f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 334:	eb 9c                	jmp    2d2 <printint+0x1a>
 336:	66 90                	xchg   %ax,%ax

00000338 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	57                   	push   %edi
 33c:	56                   	push   %esi
 33d:	53                   	push   %ebx
 33e:	83 ec 3c             	sub    $0x3c,%esp
 341:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 344:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 347:	8a 03                	mov    (%ebx),%al
 349:	84 c0                	test   %al,%al
 34b:	0f 84 bb 00 00 00    	je     40c <printf+0xd4>
printf(int fd, char *fmt, ...)
 351:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 352:	8d 55 10             	lea    0x10(%ebp),%edx
 355:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 358:	31 ff                	xor    %edi,%edi
 35a:	eb 2f                	jmp    38b <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 35c:	83 f9 25             	cmp    $0x25,%ecx
 35f:	0f 84 af 00 00 00    	je     414 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 365:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36f:	00 
 370:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 373:	89 44 24 04          	mov    %eax,0x4(%esp)
 377:	89 34 24             	mov    %esi,(%esp)
 37a:	e8 90 fe ff ff       	call   20f <write>
 37f:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 380:	8a 43 ff             	mov    -0x1(%ebx),%al
 383:	84 c0                	test   %al,%al
 385:	0f 84 81 00 00 00    	je     40c <printf+0xd4>
    c = fmt[i] & 0xff;
 38b:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 38e:	85 ff                	test   %edi,%edi
 390:	74 ca                	je     35c <printf+0x24>
      }
    } else if(state == '%'){
 392:	83 ff 25             	cmp    $0x25,%edi
 395:	75 e8                	jne    37f <printf+0x47>
      if(c == 'd'){
 397:	83 f9 64             	cmp    $0x64,%ecx
 39a:	0f 84 14 01 00 00    	je     4b4 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3a0:	83 f9 78             	cmp    $0x78,%ecx
 3a3:	74 7b                	je     420 <printf+0xe8>
 3a5:	83 f9 70             	cmp    $0x70,%ecx
 3a8:	74 76                	je     420 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3aa:	83 f9 73             	cmp    $0x73,%ecx
 3ad:	0f 84 91 00 00 00    	je     444 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3b3:	83 f9 63             	cmp    $0x63,%ecx
 3b6:	0f 84 cc 00 00 00    	je     488 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3bc:	83 f9 25             	cmp    $0x25,%ecx
 3bf:	0f 84 13 01 00 00    	je     4d8 <printf+0x1a0>
 3c5:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 3c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d0:	00 
 3d1:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 3d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d8:	89 34 24             	mov    %esi,(%esp)
 3db:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 3de:	e8 2c fe ff ff       	call   20f <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 3e3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 3e6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 3e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f0:	00 
 3f1:	8d 55 e7             	lea    -0x19(%ebp),%edx
 3f4:	89 54 24 04          	mov    %edx,0x4(%esp)
 3f8:	89 34 24             	mov    %esi,(%esp)
 3fb:	e8 0f fe ff ff       	call   20f <write>
      }
      state = 0;
 400:	31 ff                	xor    %edi,%edi
 402:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 403:	8a 43 ff             	mov    -0x1(%ebx),%al
 406:	84 c0                	test   %al,%al
 408:	75 81                	jne    38b <printf+0x53>
 40a:	66 90                	xchg   %ax,%ax
    }
  }
}
 40c:	83 c4 3c             	add    $0x3c,%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
        state = '%';
 414:	bf 25 00 00 00       	mov    $0x25,%edi
 419:	e9 61 ff ff ff       	jmp    37f <printf+0x47>
 41e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 427:	b9 10 00 00 00       	mov    $0x10,%ecx
 42c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 42f:	8b 10                	mov    (%eax),%edx
 431:	89 f0                	mov    %esi,%eax
 433:	e8 80 fe ff ff       	call   2b8 <printint>
        ap++;
 438:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 43c:	31 ff                	xor    %edi,%edi
        ap++;
 43e:	e9 3c ff ff ff       	jmp    37f <printf+0x47>
 443:	90                   	nop
        s = (char*)*ap;
 444:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 447:	8b 3a                	mov    (%edx),%edi
        ap++;
 449:	83 c2 04             	add    $0x4,%edx
 44c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 44f:	85 ff                	test   %edi,%edi
 451:	0f 84 a3 00 00 00    	je     4fa <printf+0x1c2>
        while(*s != 0){
 457:	8a 07                	mov    (%edi),%al
 459:	84 c0                	test   %al,%al
 45b:	74 24                	je     481 <printf+0x149>
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 463:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46a:	00 
 46b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 46e:	89 44 24 04          	mov    %eax,0x4(%esp)
 472:	89 34 24             	mov    %esi,(%esp)
 475:	e8 95 fd ff ff       	call   20f <write>
          s++;
 47a:	47                   	inc    %edi
        while(*s != 0){
 47b:	8a 07                	mov    (%edi),%al
 47d:	84 c0                	test   %al,%al
 47f:	75 df                	jne    460 <printf+0x128>
      state = 0;
 481:	31 ff                	xor    %edi,%edi
 483:	e9 f7 fe ff ff       	jmp    37f <printf+0x47>
        putc(fd, *ap);
 488:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 48b:	8b 02                	mov    (%edx),%eax
 48d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 490:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 497:	00 
 498:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 49b:	89 44 24 04          	mov    %eax,0x4(%esp)
 49f:	89 34 24             	mov    %esi,(%esp)
 4a2:	e8 68 fd ff ff       	call   20f <write>
        ap++;
 4a7:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4ab:	31 ff                	xor    %edi,%edi
 4ad:	e9 cd fe ff ff       	jmp    37f <printf+0x47>
 4b2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 4b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4bb:	b1 0a                	mov    $0xa,%cl
 4bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c0:	8b 10                	mov    (%eax),%edx
 4c2:	89 f0                	mov    %esi,%eax
 4c4:	e8 ef fd ff ff       	call   2b8 <printint>
        ap++;
 4c9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4cd:	66 31 ff             	xor    %di,%di
 4d0:	e9 aa fe ff ff       	jmp    37f <printf+0x47>
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
 4d8:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 4dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e3:	00 
 4e4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	89 34 24             	mov    %esi,(%esp)
 4ee:	e8 1c fd ff ff       	call   20f <write>
      state = 0;
 4f3:	31 ff                	xor    %edi,%edi
 4f5:	e9 85 fe ff ff       	jmp    37f <printf+0x47>
          s = "(null)";
 4fa:	bf 5a 06 00 00       	mov    $0x65a,%edi
 4ff:	e9 53 ff ff ff       	jmp    457 <printf+0x11f>

00000504 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	57                   	push   %edi
 508:	56                   	push   %esi
 509:	53                   	push   %ebx
 50a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 50d:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 510:	a1 f4 08 00 00       	mov    0x8f4,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 515:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 517:	39 d0                	cmp    %edx,%eax
 519:	72 11                	jb     52c <free+0x28>
 51b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 51c:	39 c8                	cmp    %ecx,%eax
 51e:	72 04                	jb     524 <free+0x20>
 520:	39 ca                	cmp    %ecx,%edx
 522:	72 10                	jb     534 <free+0x30>
 524:	89 c8                	mov    %ecx,%eax
 526:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 528:	39 d0                	cmp    %edx,%eax
 52a:	73 f0                	jae    51c <free+0x18>
 52c:	39 ca                	cmp    %ecx,%edx
 52e:	72 04                	jb     534 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 530:	39 c8                	cmp    %ecx,%eax
 532:	72 f0                	jb     524 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 534:	8b 73 fc             	mov    -0x4(%ebx),%esi
 537:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 53a:	39 cf                	cmp    %ecx,%edi
 53c:	74 1a                	je     558 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 53e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 541:	8b 48 04             	mov    0x4(%eax),%ecx
 544:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 547:	39 f2                	cmp    %esi,%edx
 549:	74 24                	je     56f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 54b:	89 10                	mov    %edx,(%eax)
  freep = p;
 54d:	a3 f4 08 00 00       	mov    %eax,0x8f4
}
 552:	5b                   	pop    %ebx
 553:	5e                   	pop    %esi
 554:	5f                   	pop    %edi
 555:	5d                   	pop    %ebp
 556:	c3                   	ret    
 557:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 558:	03 71 04             	add    0x4(%ecx),%esi
 55b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 55e:	8b 08                	mov    (%eax),%ecx
 560:	8b 09                	mov    (%ecx),%ecx
 562:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 565:	8b 48 04             	mov    0x4(%eax),%ecx
 568:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 56b:	39 f2                	cmp    %esi,%edx
 56d:	75 dc                	jne    54b <free+0x47>
    p->s.size += bp->s.size;
 56f:	03 4b fc             	add    -0x4(%ebx),%ecx
 572:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 575:	8b 53 f8             	mov    -0x8(%ebx),%edx
 578:	89 10                	mov    %edx,(%eax)
  freep = p;
 57a:	a3 f4 08 00 00       	mov    %eax,0x8f4
}
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    

00000584 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	56                   	push   %esi
 589:	53                   	push   %ebx
 58a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58d:	8b 75 08             	mov    0x8(%ebp),%esi
 590:	83 c6 07             	add    $0x7,%esi
 593:	c1 ee 03             	shr    $0x3,%esi
 596:	46                   	inc    %esi
  if((prevp = freep) == 0){
 597:	8b 15 f4 08 00 00    	mov    0x8f4,%edx
 59d:	85 d2                	test   %edx,%edx
 59f:	0f 84 8d 00 00 00    	je     632 <malloc+0xae>
 5a5:	8b 02                	mov    (%edx),%eax
 5a7:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5aa:	39 ce                	cmp    %ecx,%esi
 5ac:	76 52                	jbe    600 <malloc+0x7c>
 5ae:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 5b5:	eb 0a                	jmp    5c1 <malloc+0x3d>
 5b7:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ba:	8b 48 04             	mov    0x4(%eax),%ecx
 5bd:	39 ce                	cmp    %ecx,%esi
 5bf:	76 3f                	jbe    600 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5c1:	89 c2                	mov    %eax,%edx
 5c3:	3b 05 f4 08 00 00    	cmp    0x8f4,%eax
 5c9:	75 ed                	jne    5b8 <malloc+0x34>
  if(nu < 4096)
 5cb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 5d1:	76 4d                	jbe    620 <malloc+0x9c>
 5d3:	89 d8                	mov    %ebx,%eax
 5d5:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 a0 fc ff ff       	call   27f <sbrk>
  if(p == (char*)-1)
 5df:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e2:	74 18                	je     5fc <malloc+0x78>
  hp->s.size = nu;
 5e4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 5e7:	83 c0 08             	add    $0x8,%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 12 ff ff ff       	call   504 <free>
  return freep;
 5f2:	8b 15 f4 08 00 00    	mov    0x8f4,%edx
      if((p = morecore(nunits)) == 0)
 5f8:	85 d2                	test   %edx,%edx
 5fa:	75 bc                	jne    5b8 <malloc+0x34>
        return 0;
 5fc:	31 c0                	xor    %eax,%eax
 5fe:	eb 18                	jmp    618 <malloc+0x94>
      if(p->s.size == nunits)
 600:	39 ce                	cmp    %ecx,%esi
 602:	74 28                	je     62c <malloc+0xa8>
        p->s.size -= nunits;
 604:	29 f1                	sub    %esi,%ecx
 606:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 609:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 60c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 60f:	89 15 f4 08 00 00    	mov    %edx,0x8f4
      return (void*)(p + 1);
 615:	83 c0 08             	add    $0x8,%eax
  }
}
 618:	83 c4 1c             	add    $0x1c,%esp
 61b:	5b                   	pop    %ebx
 61c:	5e                   	pop    %esi
 61d:	5f                   	pop    %edi
 61e:	5d                   	pop    %ebp
 61f:	c3                   	ret    
  if(nu < 4096)
 620:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 625:	bf 00 10 00 00       	mov    $0x1000,%edi
 62a:	eb ab                	jmp    5d7 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 62c:	8b 08                	mov    (%eax),%ecx
 62e:	89 0a                	mov    %ecx,(%edx)
 630:	eb dd                	jmp    60f <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 632:	c7 05 f4 08 00 00 f8 	movl   $0x8f8,0x8f4
 639:	08 00 00 
 63c:	c7 05 f8 08 00 00 f8 	movl   $0x8f8,0x8f8
 643:	08 00 00 
    base.s.size = 0;
 646:	c7 05 fc 08 00 00 00 	movl   $0x0,0x8fc
 64d:	00 00 00 
 650:	b8 f8 08 00 00       	mov    $0x8f8,%eax
 655:	e9 54 ff ff ff       	jmp    5ae <malloc+0x2a>
