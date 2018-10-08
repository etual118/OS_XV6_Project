
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(argc != 3){
   d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  11:	74 19                	je     2c <main+0x2c>
    printf(2, "Usage: ln old new\n");
  13:	c7 44 24 04 a2 06 00 	movl   $0x6a2,0x4(%esp)
  1a:	00 
  1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  22:	e8 59 03 00 00       	call   380 <printf>
    exit();
  27:	e8 0b 02 00 00       	call   237 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2c:	8b 43 08             	mov    0x8(%ebx),%eax
  2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  33:	8b 43 04             	mov    0x4(%ebx),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 59 02 00 00       	call   297 <link>
  3e:	85 c0                	test   %eax,%eax
  40:	78 05                	js     47 <main+0x47>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  42:	e8 f0 01 00 00       	call   237 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  47:	8b 43 08             	mov    0x8(%ebx),%eax
  4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	89 44 24 08          	mov    %eax,0x8(%esp)
  55:	c7 44 24 04 b5 06 00 	movl   $0x6b5,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  64:	e8 17 03 00 00       	call   380 <printf>
  69:	eb d7                	jmp    42 <main+0x42>
  6b:	90                   	nop

0000006c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	53                   	push   %ebx
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	89 c2                	mov    %eax,%edx
  78:	8a 19                	mov    (%ecx),%bl
  7a:	88 1a                	mov    %bl,(%edx)
  7c:	42                   	inc    %edx
  7d:	41                   	inc    %ecx
  7e:	84 db                	test   %bl,%bl
  80:	75 f6                	jne    78 <strcpy+0xc>
    ;
  return os;
}
  82:	5b                   	pop    %ebx
  83:	5d                   	pop    %ebp
  84:	c3                   	ret    
  85:	8d 76 00             	lea    0x0(%esi),%esi

00000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	56                   	push   %esi
  8c:	53                   	push   %ebx
  8d:	8b 55 08             	mov    0x8(%ebp),%edx
  90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  93:	0f b6 02             	movzbl (%edx),%eax
  96:	0f b6 19             	movzbl (%ecx),%ebx
  99:	84 c0                	test   %al,%al
  9b:	75 14                	jne    b1 <strcmp+0x29>
  9d:	eb 1d                	jmp    bc <strcmp+0x34>
  9f:	90                   	nop
    p++, q++;
  a0:	42                   	inc    %edx
  a1:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  a4:	0f b6 02             	movzbl (%edx),%eax
  a7:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  ab:	84 c0                	test   %al,%al
  ad:	74 0d                	je     bc <strcmp+0x34>
    p++, q++;
  af:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  b1:	38 d8                	cmp    %bl,%al
  b3:	74 eb                	je     a0 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b5:	29 d8                	sub    %ebx,%eax
}
  b7:	5b                   	pop    %ebx
  b8:	5e                   	pop    %esi
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    
  bb:	90                   	nop
  while(*p && *p == *q)
  bc:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  be:	29 d8                	sub    %ebx,%eax
}
  c0:	5b                   	pop    %ebx
  c1:	5e                   	pop    %esi
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <strlen>:

uint
strlen(char *s)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ca:	80 39 00             	cmpb   $0x0,(%ecx)
  cd:	74 10                	je     df <strlen+0x1b>
  cf:	31 d2                	xor    %edx,%edx
  d1:	8d 76 00             	lea    0x0(%esi),%esi
  d4:	42                   	inc    %edx
  d5:	89 d0                	mov    %edx,%eax
  d7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  db:	75 f7                	jne    d4 <strlen+0x10>
    ;
  return n;
}
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  for(n = 0; s[n]; n++)
  df:	31 c0                	xor    %eax,%eax
}
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    
  e3:	90                   	nop

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
  e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  eb:	89 d7                	mov    %edx,%edi
  ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	fc                   	cld    
  f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f6:	89 d0                	mov    %edx,%eax
  f8:	5f                   	pop    %edi
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    
  fb:	90                   	nop

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 105:	8a 10                	mov    (%eax),%dl
 107:	84 d2                	test   %dl,%dl
 109:	75 0c                	jne    117 <strchr+0x1b>
 10b:	eb 13                	jmp    120 <strchr+0x24>
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	40                   	inc    %eax
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	74 09                	je     120 <strchr+0x24>
    if(*s == c)
 117:	38 ca                	cmp    %cl,%dl
 119:	75 f5                	jne    110 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 120:	31 c0                	xor    %eax,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 12f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 132:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 134:	8d 73 01             	lea    0x1(%ebx),%esi
 137:	3b 75 0c             	cmp    0xc(%ebp),%esi
 13a:	7d 40                	jge    17c <gets+0x58>
    cc = read(0, &c, 1);
 13c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 143:	00 
 144:	89 7c 24 04          	mov    %edi,0x4(%esp)
 148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14f:	e8 fb 00 00 00       	call   24f <read>
    if(cc < 1)
 154:	85 c0                	test   %eax,%eax
 156:	7e 24                	jle    17c <gets+0x58>
      break;
    buf[i++] = c;
 158:	8a 45 e7             	mov    -0x19(%ebp),%al
 15b:	8b 55 08             	mov    0x8(%ebp),%edx
 15e:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 162:	3c 0a                	cmp    $0xa,%al
 164:	74 06                	je     16c <gets+0x48>
 166:	89 f3                	mov    %esi,%ebx
 168:	3c 0d                	cmp    $0xd,%al
 16a:	75 c8                	jne    134 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 173:	83 c4 2c             	add    $0x2c,%esp
 176:	5b                   	pop    %ebx
 177:	5e                   	pop    %esi
 178:	5f                   	pop    %edi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
 17b:	90                   	nop
    if(cc < 1)
 17c:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 185:	83 c4 2c             	add    $0x2c,%esp
 188:	5b                   	pop    %ebx
 189:	5e                   	pop    %esi
 18a:	5f                   	pop    %edi
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
 18d:	8d 76 00             	lea    0x0(%esi),%esi

00000190 <stat>:

int
stat(char *n, struct stat *st)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 19f:	00 
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 cc 00 00 00       	call   277 <open>
 1ab:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1ad:	85 c0                	test   %eax,%eax
 1af:	78 23                	js     1d4 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b8:	89 1c 24             	mov    %ebx,(%esp)
 1bb:	e8 cf 00 00 00       	call   28f <fstat>
 1c0:	89 c6                	mov    %eax,%esi
  close(fd);
 1c2:	89 1c 24             	mov    %ebx,(%esp)
 1c5:	e8 95 00 00 00       	call   25f <close>
  return r;
}
 1ca:	89 f0                	mov    %esi,%eax
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	90                   	nop
    return -1;
 1d4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d9:	eb ef                	jmp    1ca <stat+0x3a>
 1db:	90                   	nop

000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	53                   	push   %ebx
 1e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e3:	0f be 11             	movsbl (%ecx),%edx
 1e6:	8d 42 d0             	lea    -0x30(%edx),%eax
 1e9:	3c 09                	cmp    $0x9,%al
 1eb:	b8 00 00 00 00       	mov    $0x0,%eax
 1f0:	77 15                	ja     207 <atoi+0x2b>
 1f2:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1f4:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1f7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 1fb:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 1fc:	0f be 11             	movsbl (%ecx),%edx
 1ff:	8d 5a d0             	lea    -0x30(%edx),%ebx
 202:	80 fb 09             	cmp    $0x9,%bl
 205:	76 ed                	jbe    1f4 <atoi+0x18>
  return n;
}
 207:	5b                   	pop    %ebx
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    
 20a:	66 90                	xchg   %ax,%ax

0000020c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	56                   	push   %esi
 210:	53                   	push   %ebx
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 217:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 21a:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21c:	85 f6                	test   %esi,%esi
 21e:	7e 0b                	jle    22b <memmove+0x1f>
    *dst++ = *src++;
 220:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 223:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 226:	42                   	inc    %edx
  while(n-- > 0)
 227:	39 f2                	cmp    %esi,%edx
 229:	75 f5                	jne    220 <memmove+0x14>
  return vdst;
}
 22b:	5b                   	pop    %ebx
 22c:	5e                   	pop    %esi
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    

0000022f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22f:	b8 01 00 00 00       	mov    $0x1,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <exit>:
SYSCALL(exit)
 237:	b8 02 00 00 00       	mov    $0x2,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <wait>:
SYSCALL(wait)
 23f:	b8 03 00 00 00       	mov    $0x3,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <pipe>:
SYSCALL(pipe)
 247:	b8 04 00 00 00       	mov    $0x4,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <read>:
SYSCALL(read)
 24f:	b8 05 00 00 00       	mov    $0x5,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <write>:
SYSCALL(write)
 257:	b8 10 00 00 00       	mov    $0x10,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <close>:
SYSCALL(close)
 25f:	b8 15 00 00 00       	mov    $0x15,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <kill>:
SYSCALL(kill)
 267:	b8 06 00 00 00       	mov    $0x6,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <exec>:
SYSCALL(exec)
 26f:	b8 07 00 00 00       	mov    $0x7,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <open>:
SYSCALL(open)
 277:	b8 0f 00 00 00       	mov    $0xf,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <mknod>:
SYSCALL(mknod)
 27f:	b8 11 00 00 00       	mov    $0x11,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <unlink>:
SYSCALL(unlink)
 287:	b8 12 00 00 00       	mov    $0x12,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <fstat>:
SYSCALL(fstat)
 28f:	b8 08 00 00 00       	mov    $0x8,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <link>:
SYSCALL(link)
 297:	b8 13 00 00 00       	mov    $0x13,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <mkdir>:
SYSCALL(mkdir)
 29f:	b8 14 00 00 00       	mov    $0x14,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <chdir>:
SYSCALL(chdir)
 2a7:	b8 09 00 00 00       	mov    $0x9,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <dup>:
SYSCALL(dup)
 2af:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <getpid>:
SYSCALL(getpid)
 2b7:	b8 0b 00 00 00       	mov    $0xb,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <getppid>:
SYSCALL(getppid)
 2bf:	b8 17 00 00 00       	mov    $0x17,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <sbrk>:
SYSCALL(sbrk)
 2c7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <sleep>:
SYSCALL(sleep)
 2cf:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <uptime>:
SYSCALL(uptime)
 2d7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <myfunction>:
SYSCALL(myfunction)
 2df:	b8 16 00 00 00       	mov    $0x16,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <yield>:
SYSCALL(yield)
 2e7:	b8 18 00 00 00       	mov    $0x18,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <getlev>:
SYSCALL(getlev)
 2ef:	b8 19 00 00 00       	mov    $0x19,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <set_cpu_share>:
 2f7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    
 2ff:	90                   	nop

00000300 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
 305:	53                   	push   %ebx
 306:	83 ec 3c             	sub    $0x3c,%esp
 309:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 30b:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 30d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 310:	85 db                	test   %ebx,%ebx
 312:	74 04                	je     318 <printint+0x18>
 314:	85 d2                	test   %edx,%edx
 316:	78 5d                	js     375 <printint+0x75>
  neg = 0;
 318:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 31a:	31 f6                	xor    %esi,%esi
 31c:	eb 04                	jmp    322 <printint+0x22>
 31e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 320:	89 d6                	mov    %edx,%esi
 322:	31 d2                	xor    %edx,%edx
 324:	f7 f1                	div    %ecx
 326:	8a 92 d0 06 00 00    	mov    0x6d0(%edx),%dl
 32c:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 330:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 333:	85 c0                	test   %eax,%eax
 335:	75 e9                	jne    320 <printint+0x20>
  if(neg)
 337:	85 db                	test   %ebx,%ebx
 339:	74 08                	je     343 <printint+0x43>
    buf[i++] = '-';
 33b:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 340:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 343:	8d 5a ff             	lea    -0x1(%edx),%ebx
 346:	8d 75 d7             	lea    -0x29(%ebp),%esi
 349:	8d 76 00             	lea    0x0(%esi),%esi
 34c:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 350:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 353:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 35a:	00 
 35b:	89 74 24 04          	mov    %esi,0x4(%esp)
 35f:	89 3c 24             	mov    %edi,(%esp)
 362:	e8 f0 fe ff ff       	call   257 <write>
  while(--i >= 0)
 367:	4b                   	dec    %ebx
 368:	83 fb ff             	cmp    $0xffffffff,%ebx
 36b:	75 df                	jne    34c <printint+0x4c>
    putc(fd, buf[i]);
}
 36d:	83 c4 3c             	add    $0x3c,%esp
 370:	5b                   	pop    %ebx
 371:	5e                   	pop    %esi
 372:	5f                   	pop    %edi
 373:	5d                   	pop    %ebp
 374:	c3                   	ret    
    x = -xx;
 375:	f7 d8                	neg    %eax
    neg = 1;
 377:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 37c:	eb 9c                	jmp    31a <printint+0x1a>
 37e:	66 90                	xchg   %ax,%ax

00000380 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 3c             	sub    $0x3c,%esp
 389:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 38c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 38f:	8a 03                	mov    (%ebx),%al
 391:	84 c0                	test   %al,%al
 393:	0f 84 bb 00 00 00    	je     454 <printf+0xd4>
printf(int fd, char *fmt, ...)
 399:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 39a:	8d 55 10             	lea    0x10(%ebp),%edx
 39d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 3a0:	31 ff                	xor    %edi,%edi
 3a2:	eb 2f                	jmp    3d3 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3a4:	83 f9 25             	cmp    $0x25,%ecx
 3a7:	0f 84 af 00 00 00    	je     45c <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 3ad:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 3b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b7:	00 
 3b8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bf:	89 34 24             	mov    %esi,(%esp)
 3c2:	e8 90 fe ff ff       	call   257 <write>
 3c7:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3c8:	8a 43 ff             	mov    -0x1(%ebx),%al
 3cb:	84 c0                	test   %al,%al
 3cd:	0f 84 81 00 00 00    	je     454 <printf+0xd4>
    c = fmt[i] & 0xff;
 3d3:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3d6:	85 ff                	test   %edi,%edi
 3d8:	74 ca                	je     3a4 <printf+0x24>
      }
    } else if(state == '%'){
 3da:	83 ff 25             	cmp    $0x25,%edi
 3dd:	75 e8                	jne    3c7 <printf+0x47>
      if(c == 'd'){
 3df:	83 f9 64             	cmp    $0x64,%ecx
 3e2:	0f 84 14 01 00 00    	je     4fc <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3e8:	83 f9 78             	cmp    $0x78,%ecx
 3eb:	74 7b                	je     468 <printf+0xe8>
 3ed:	83 f9 70             	cmp    $0x70,%ecx
 3f0:	74 76                	je     468 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3f2:	83 f9 73             	cmp    $0x73,%ecx
 3f5:	0f 84 91 00 00 00    	je     48c <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3fb:	83 f9 63             	cmp    $0x63,%ecx
 3fe:	0f 84 cc 00 00 00    	je     4d0 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 404:	83 f9 25             	cmp    $0x25,%ecx
 407:	0f 84 13 01 00 00    	je     520 <printf+0x1a0>
 40d:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 411:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 418:	00 
 419:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 41c:	89 44 24 04          	mov    %eax,0x4(%esp)
 420:	89 34 24             	mov    %esi,(%esp)
 423:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 426:	e8 2c fe ff ff       	call   257 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 42b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 42e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 431:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 438:	00 
 439:	8d 55 e7             	lea    -0x19(%ebp),%edx
 43c:	89 54 24 04          	mov    %edx,0x4(%esp)
 440:	89 34 24             	mov    %esi,(%esp)
 443:	e8 0f fe ff ff       	call   257 <write>
      }
      state = 0;
 448:	31 ff                	xor    %edi,%edi
 44a:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 44b:	8a 43 ff             	mov    -0x1(%ebx),%al
 44e:	84 c0                	test   %al,%al
 450:	75 81                	jne    3d3 <printf+0x53>
 452:	66 90                	xchg   %ax,%ax
    }
  }
}
 454:	83 c4 3c             	add    $0x3c,%esp
 457:	5b                   	pop    %ebx
 458:	5e                   	pop    %esi
 459:	5f                   	pop    %edi
 45a:	5d                   	pop    %ebp
 45b:	c3                   	ret    
        state = '%';
 45c:	bf 25 00 00 00       	mov    $0x25,%edi
 461:	e9 61 ff ff ff       	jmp    3c7 <printf+0x47>
 466:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 468:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 46f:	b9 10 00 00 00       	mov    $0x10,%ecx
 474:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 477:	8b 10                	mov    (%eax),%edx
 479:	89 f0                	mov    %esi,%eax
 47b:	e8 80 fe ff ff       	call   300 <printint>
        ap++;
 480:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 484:	31 ff                	xor    %edi,%edi
        ap++;
 486:	e9 3c ff ff ff       	jmp    3c7 <printf+0x47>
 48b:	90                   	nop
        s = (char*)*ap;
 48c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 48f:	8b 3a                	mov    (%edx),%edi
        ap++;
 491:	83 c2 04             	add    $0x4,%edx
 494:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 497:	85 ff                	test   %edi,%edi
 499:	0f 84 a3 00 00 00    	je     542 <printf+0x1c2>
        while(*s != 0){
 49f:	8a 07                	mov    (%edi),%al
 4a1:	84 c0                	test   %al,%al
 4a3:	74 24                	je     4c9 <printf+0x149>
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
 4a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b2:	00 
 4b3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 4b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ba:	89 34 24             	mov    %esi,(%esp)
 4bd:	e8 95 fd ff ff       	call   257 <write>
          s++;
 4c2:	47                   	inc    %edi
        while(*s != 0){
 4c3:	8a 07                	mov    (%edi),%al
 4c5:	84 c0                	test   %al,%al
 4c7:	75 df                	jne    4a8 <printf+0x128>
      state = 0;
 4c9:	31 ff                	xor    %edi,%edi
 4cb:	e9 f7 fe ff ff       	jmp    3c7 <printf+0x47>
        putc(fd, *ap);
 4d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4d3:	8b 02                	mov    (%edx),%eax
 4d5:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4df:	00 
 4e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	89 34 24             	mov    %esi,(%esp)
 4ea:	e8 68 fd ff ff       	call   257 <write>
        ap++;
 4ef:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4f3:	31 ff                	xor    %edi,%edi
 4f5:	e9 cd fe ff ff       	jmp    3c7 <printf+0x47>
 4fa:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 4fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 503:	b1 0a                	mov    $0xa,%cl
 505:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 508:	8b 10                	mov    (%eax),%edx
 50a:	89 f0                	mov    %esi,%eax
 50c:	e8 ef fd ff ff       	call   300 <printint>
        ap++;
 511:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 515:	66 31 ff             	xor    %di,%di
 518:	e9 aa fe ff ff       	jmp    3c7 <printf+0x47>
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 524:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52b:	00 
 52c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 52f:	89 44 24 04          	mov    %eax,0x4(%esp)
 533:	89 34 24             	mov    %esi,(%esp)
 536:	e8 1c fd ff ff       	call   257 <write>
      state = 0;
 53b:	31 ff                	xor    %edi,%edi
 53d:	e9 85 fe ff ff       	jmp    3c7 <printf+0x47>
          s = "(null)";
 542:	bf c9 06 00 00       	mov    $0x6c9,%edi
 547:	e9 53 ff ff ff       	jmp    49f <printf+0x11f>

0000054c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 555:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 558:	a1 64 09 00 00       	mov    0x964,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55d:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55f:	39 d0                	cmp    %edx,%eax
 561:	72 11                	jb     574 <free+0x28>
 563:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 564:	39 c8                	cmp    %ecx,%eax
 566:	72 04                	jb     56c <free+0x20>
 568:	39 ca                	cmp    %ecx,%edx
 56a:	72 10                	jb     57c <free+0x30>
 56c:	89 c8                	mov    %ecx,%eax
 56e:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 570:	39 d0                	cmp    %edx,%eax
 572:	73 f0                	jae    564 <free+0x18>
 574:	39 ca                	cmp    %ecx,%edx
 576:	72 04                	jb     57c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 578:	39 c8                	cmp    %ecx,%eax
 57a:	72 f0                	jb     56c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 57c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57f:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 582:	39 cf                	cmp    %ecx,%edi
 584:	74 1a                	je     5a0 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 586:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 589:	8b 48 04             	mov    0x4(%eax),%ecx
 58c:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 58f:	39 f2                	cmp    %esi,%edx
 591:	74 24                	je     5b7 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 593:	89 10                	mov    %edx,(%eax)
  freep = p;
 595:	a3 64 09 00 00       	mov    %eax,0x964
}
 59a:	5b                   	pop    %ebx
 59b:	5e                   	pop    %esi
 59c:	5f                   	pop    %edi
 59d:	5d                   	pop    %ebp
 59e:	c3                   	ret    
 59f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5a0:	03 71 04             	add    0x4(%ecx),%esi
 5a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a6:	8b 08                	mov    (%eax),%ecx
 5a8:	8b 09                	mov    (%ecx),%ecx
 5aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 48 04             	mov    0x4(%eax),%ecx
 5b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5b3:	39 f2                	cmp    %esi,%edx
 5b5:	75 dc                	jne    593 <free+0x47>
    p->s.size += bp->s.size;
 5b7:	03 4b fc             	add    -0x4(%ebx),%ecx
 5ba:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5bd:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5c0:	89 10                	mov    %edx,(%eax)
  freep = p;
 5c2:	a3 64 09 00 00       	mov    %eax,0x964
}
 5c7:	5b                   	pop    %ebx
 5c8:	5e                   	pop    %esi
 5c9:	5f                   	pop    %edi
 5ca:	5d                   	pop    %ebp
 5cb:	c3                   	ret    

000005cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	57                   	push   %edi
 5d0:	56                   	push   %esi
 5d1:	53                   	push   %ebx
 5d2:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d5:	8b 75 08             	mov    0x8(%ebp),%esi
 5d8:	83 c6 07             	add    $0x7,%esi
 5db:	c1 ee 03             	shr    $0x3,%esi
 5de:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5df:	8b 15 64 09 00 00    	mov    0x964,%edx
 5e5:	85 d2                	test   %edx,%edx
 5e7:	0f 84 8d 00 00 00    	je     67a <malloc+0xae>
 5ed:	8b 02                	mov    (%edx),%eax
 5ef:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5f2:	39 ce                	cmp    %ecx,%esi
 5f4:	76 52                	jbe    648 <malloc+0x7c>
 5f6:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 5fd:	eb 0a                	jmp    609 <malloc+0x3d>
 5ff:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 600:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 602:	8b 48 04             	mov    0x4(%eax),%ecx
 605:	39 ce                	cmp    %ecx,%esi
 607:	76 3f                	jbe    648 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 609:	89 c2                	mov    %eax,%edx
 60b:	3b 05 64 09 00 00    	cmp    0x964,%eax
 611:	75 ed                	jne    600 <malloc+0x34>
  if(nu < 4096)
 613:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 619:	76 4d                	jbe    668 <malloc+0x9c>
 61b:	89 d8                	mov    %ebx,%eax
 61d:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 a0 fc ff ff       	call   2c7 <sbrk>
  if(p == (char*)-1)
 627:	83 f8 ff             	cmp    $0xffffffff,%eax
 62a:	74 18                	je     644 <malloc+0x78>
  hp->s.size = nu;
 62c:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 62f:	83 c0 08             	add    $0x8,%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 12 ff ff ff       	call   54c <free>
  return freep;
 63a:	8b 15 64 09 00 00    	mov    0x964,%edx
      if((p = morecore(nunits)) == 0)
 640:	85 d2                	test   %edx,%edx
 642:	75 bc                	jne    600 <malloc+0x34>
        return 0;
 644:	31 c0                	xor    %eax,%eax
 646:	eb 18                	jmp    660 <malloc+0x94>
      if(p->s.size == nunits)
 648:	39 ce                	cmp    %ecx,%esi
 64a:	74 28                	je     674 <malloc+0xa8>
        p->s.size -= nunits;
 64c:	29 f1                	sub    %esi,%ecx
 64e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 651:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 654:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 657:	89 15 64 09 00 00    	mov    %edx,0x964
      return (void*)(p + 1);
 65d:	83 c0 08             	add    $0x8,%eax
  }
}
 660:	83 c4 1c             	add    $0x1c,%esp
 663:	5b                   	pop    %ebx
 664:	5e                   	pop    %esi
 665:	5f                   	pop    %edi
 666:	5d                   	pop    %ebp
 667:	c3                   	ret    
  if(nu < 4096)
 668:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 66d:	bf 00 10 00 00       	mov    $0x1000,%edi
 672:	eb ab                	jmp    61f <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 674:	8b 08                	mov    (%eax),%ecx
 676:	89 0a                	mov    %ecx,(%edx)
 678:	eb dd                	jmp    657 <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 67a:	c7 05 64 09 00 00 68 	movl   $0x968,0x964
 681:	09 00 00 
 684:	c7 05 68 09 00 00 68 	movl   $0x968,0x968
 68b:	09 00 00 
    base.s.size = 0;
 68e:	c7 05 6c 09 00 00 00 	movl   $0x0,0x96c
 695:	00 00 00 
 698:	b8 68 09 00 00       	mov    $0x968,%eax
 69d:	e9 54 ff ff ff       	jmp    5f6 <malloc+0x2a>
