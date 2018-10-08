
_test_stride:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define LIFETIME        1000        // (ticks)
#define COUNT_PERIOD    1000000     // (iteration)

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
  int cnt = 0;
  int cpu_share;
  uint start_tick;
  uint curr_tick;

  if (argc < 2) {
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 62                	jle    74 <main+0x74>
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
    exit();
  }

  cpu_share = atoi(argv[1]);
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
  15:	8b 40 04             	mov    0x4(%eax),%eax
  18:	89 04 24             	mov    %eax,(%esp)
  1b:	e8 f8 01 00 00       	call   218 <atoi>
  20:	89 c7                	mov    %eax,%edi

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 09 03 00 00       	call   333 <set_cpu_share>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 5f                	js     8d <main+0x8d>
    printf(1, "cannot set cpu share\n");
    exit();
  }

  // Get start time
  start_tick = uptime();
  2e:	e8 e0 02 00 00       	call   313 <uptime>
  33:	89 c6                	mov    %eax,%esi
  int cnt = 0;
  35:	31 db                	xor    %ebx,%ebx
  37:	b8 40 42 0f 00       	mov    $0xf4240,%eax
  i = 0;
  while (1) {
    i++;

    // Prevent code optimization
    __sync_synchronize();
  3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    if (i == COUNT_PERIOD) {
  41:	48                   	dec    %eax
  42:	75 f8                	jne    3c <main+0x3c>
      cnt++;
  44:	43                   	inc    %ebx

      // Get current time
      curr_tick = uptime();
  45:	e8 c9 02 00 00       	call   313 <uptime>

      if (curr_tick - start_tick > LIFETIME) {
  4a:	29 f0                	sub    %esi,%eax
  4c:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  51:	76 e4                	jbe    37 <main+0x37>
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
  53:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  57:	89 7c 24 08          	mov    %edi,0x8(%esp)
  5b:	c7 44 24 04 1e 07 00 	movl   $0x71e,0x4(%esp)
  62:	00 
  63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6a:	e8 4d 03 00 00       	call   3bc <printf>
      }
      i = 0;
    }
  }

  exit();
  6f:	e8 ff 01 00 00       	call   273 <exit>
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
  74:	c7 44 24 04 e0 06 00 	movl   $0x6e0,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 34 03 00 00       	call   3bc <printf>
    exit();
  88:	e8 e6 01 00 00       	call   273 <exit>
    printf(1, "cannot set cpu share\n");
  8d:	c7 44 24 04 08 07 00 	movl   $0x708,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 1b 03 00 00       	call   3bc <printf>
    exit();
  a1:	e8 cd 01 00 00       	call   273 <exit>
  a6:	66 90                	xchg   %ax,%ax

000000a8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	53                   	push   %ebx
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b2:	89 c2                	mov    %eax,%edx
  b4:	8a 19                	mov    (%ecx),%bl
  b6:	88 1a                	mov    %bl,(%edx)
  b8:	42                   	inc    %edx
  b9:	41                   	inc    %ecx
  ba:	84 db                	test   %bl,%bl
  bc:	75 f6                	jne    b4 <strcpy+0xc>
    ;
  return os;
}
  be:	5b                   	pop    %ebx
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    
  c1:	8d 76 00             	lea    0x0(%esi),%esi

000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	56                   	push   %esi
  c8:	53                   	push   %ebx
  c9:	8b 55 08             	mov    0x8(%ebp),%edx
  cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  cf:	0f b6 02             	movzbl (%edx),%eax
  d2:	0f b6 19             	movzbl (%ecx),%ebx
  d5:	84 c0                	test   %al,%al
  d7:	75 14                	jne    ed <strcmp+0x29>
  d9:	eb 1d                	jmp    f8 <strcmp+0x34>
  db:	90                   	nop
    p++, q++;
  dc:	42                   	inc    %edx
  dd:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  e0:	0f b6 02             	movzbl (%edx),%eax
  e3:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  e7:	84 c0                	test   %al,%al
  e9:	74 0d                	je     f8 <strcmp+0x34>
    p++, q++;
  eb:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  ed:	38 d8                	cmp    %bl,%al
  ef:	74 eb                	je     dc <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  f1:	29 d8                	sub    %ebx,%eax
}
  f3:	5b                   	pop    %ebx
  f4:	5e                   	pop    %esi
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	90                   	nop
  while(*p && *p == *q)
  f8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  fa:	29 d8                	sub    %ebx,%eax
}
  fc:	5b                   	pop    %ebx
  fd:	5e                   	pop    %esi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 39 00             	cmpb   $0x0,(%ecx)
 109:	74 10                	je     11b <strlen+0x1b>
 10b:	31 d2                	xor    %edx,%edx
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	42                   	inc    %edx
 111:	89 d0                	mov    %edx,%eax
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	75 f7                	jne    110 <strlen+0x10>
    ;
  return n;
}
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    
  for(n = 0; s[n]; n++)
 11b:	31 c0                	xor    %eax,%eax
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    
 11f:	90                   	nop

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	89 d7                	mov    %edx,%edi
 129:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	90                   	nop

00000138 <strchr>:

char*
strchr(const char *s, char c)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 141:	8a 10                	mov    (%eax),%dl
 143:	84 d2                	test   %dl,%dl
 145:	75 0c                	jne    153 <strchr+0x1b>
 147:	eb 13                	jmp    15c <strchr+0x24>
 149:	8d 76 00             	lea    0x0(%esi),%esi
 14c:	40                   	inc    %eax
 14d:	8a 10                	mov    (%eax),%dl
 14f:	84 d2                	test   %dl,%dl
 151:	74 09                	je     15c <strchr+0x24>
    if(*s == c)
 153:	38 ca                	cmp    %cl,%dl
 155:	75 f5                	jne    14c <strchr+0x14>
      return (char*)s;
  return 0;
}
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 15c:	31 c0                	xor    %eax,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 169:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 16b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 16e:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 170:	8d 73 01             	lea    0x1(%ebx),%esi
 173:	3b 75 0c             	cmp    0xc(%ebp),%esi
 176:	7d 40                	jge    1b8 <gets+0x58>
    cc = read(0, &c, 1);
 178:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 17f:	00 
 180:	89 7c 24 04          	mov    %edi,0x4(%esp)
 184:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 18b:	e8 fb 00 00 00       	call   28b <read>
    if(cc < 1)
 190:	85 c0                	test   %eax,%eax
 192:	7e 24                	jle    1b8 <gets+0x58>
      break;
    buf[i++] = c;
 194:	8a 45 e7             	mov    -0x19(%ebp),%al
 197:	8b 55 08             	mov    0x8(%ebp),%edx
 19a:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 19e:	3c 0a                	cmp    $0xa,%al
 1a0:	74 06                	je     1a8 <gets+0x48>
 1a2:	89 f3                	mov    %esi,%ebx
 1a4:	3c 0d                	cmp    $0xd,%al
 1a6:	75 c8                	jne    170 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1af:	83 c4 2c             	add    $0x2c,%esp
 1b2:	5b                   	pop    %ebx
 1b3:	5e                   	pop    %esi
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	90                   	nop
    if(cc < 1)
 1b8:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1c1:	83 c4 2c             	add    $0x2c,%esp
 1c4:	5b                   	pop    %ebx
 1c5:	5e                   	pop    %esi
 1c6:	5f                   	pop    %edi
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    
 1c9:	8d 76 00             	lea    0x0(%esi),%esi

000001cc <stat>:

int
stat(char *n, struct stat *st)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	56                   	push   %esi
 1d0:	53                   	push   %ebx
 1d1:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1db:	00 
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 cc 00 00 00       	call   2b3 <open>
 1e7:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1e9:	85 c0                	test   %eax,%eax
 1eb:	78 23                	js     210 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 1ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f4:	89 1c 24             	mov    %ebx,(%esp)
 1f7:	e8 cf 00 00 00       	call   2cb <fstat>
 1fc:	89 c6                	mov    %eax,%esi
  close(fd);
 1fe:	89 1c 24             	mov    %ebx,(%esp)
 201:	e8 95 00 00 00       	call   29b <close>
  return r;
}
 206:	89 f0                	mov    %esi,%eax
 208:	83 c4 10             	add    $0x10,%esp
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    
 20f:	90                   	nop
    return -1;
 210:	be ff ff ff ff       	mov    $0xffffffff,%esi
 215:	eb ef                	jmp    206 <stat+0x3a>
 217:	90                   	nop

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	53                   	push   %ebx
 21c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21f:	0f be 11             	movsbl (%ecx),%edx
 222:	8d 42 d0             	lea    -0x30(%edx),%eax
 225:	3c 09                	cmp    $0x9,%al
 227:	b8 00 00 00 00       	mov    $0x0,%eax
 22c:	77 15                	ja     243 <atoi+0x2b>
 22e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 230:	8d 04 80             	lea    (%eax,%eax,4),%eax
 233:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 237:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 238:	0f be 11             	movsbl (%ecx),%edx
 23b:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23e:	80 fb 09             	cmp    $0x9,%bl
 241:	76 ed                	jbe    230 <atoi+0x18>
  return n;
}
 243:	5b                   	pop    %ebx
 244:	5d                   	pop    %ebp
 245:	c3                   	ret    
 246:	66 90                	xchg   %ax,%ax

00000248 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	56                   	push   %esi
 24c:	53                   	push   %ebx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 253:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 256:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 258:	85 f6                	test   %esi,%esi
 25a:	7e 0b                	jle    267 <memmove+0x1f>
    *dst++ = *src++;
 25c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 25f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 262:	42                   	inc    %edx
  while(n-- > 0)
 263:	39 f2                	cmp    %esi,%edx
 265:	75 f5                	jne    25c <memmove+0x14>
  return vdst;
}
 267:	5b                   	pop    %ebx
 268:	5e                   	pop    %esi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    

0000026b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exit>:
SYSCALL(exit)
 273:	b8 02 00 00 00       	mov    $0x2,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <wait>:
SYSCALL(wait)
 27b:	b8 03 00 00 00       	mov    $0x3,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <pipe>:
SYSCALL(pipe)
 283:	b8 04 00 00 00       	mov    $0x4,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <read>:
SYSCALL(read)
 28b:	b8 05 00 00 00       	mov    $0x5,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <write>:
SYSCALL(write)
 293:	b8 10 00 00 00       	mov    $0x10,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <close>:
SYSCALL(close)
 29b:	b8 15 00 00 00       	mov    $0x15,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <kill>:
SYSCALL(kill)
 2a3:	b8 06 00 00 00       	mov    $0x6,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <exec>:
SYSCALL(exec)
 2ab:	b8 07 00 00 00       	mov    $0x7,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <open>:
SYSCALL(open)
 2b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <mknod>:
SYSCALL(mknod)
 2bb:	b8 11 00 00 00       	mov    $0x11,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <unlink>:
SYSCALL(unlink)
 2c3:	b8 12 00 00 00       	mov    $0x12,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <fstat>:
SYSCALL(fstat)
 2cb:	b8 08 00 00 00       	mov    $0x8,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <link>:
SYSCALL(link)
 2d3:	b8 13 00 00 00       	mov    $0x13,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mkdir>:
SYSCALL(mkdir)
 2db:	b8 14 00 00 00       	mov    $0x14,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <chdir>:
SYSCALL(chdir)
 2e3:	b8 09 00 00 00       	mov    $0x9,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <dup>:
SYSCALL(dup)
 2eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <getpid>:
SYSCALL(getpid)
 2f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <getppid>:
SYSCALL(getppid)
 2fb:	b8 17 00 00 00       	mov    $0x17,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <sbrk>:
SYSCALL(sbrk)
 303:	b8 0c 00 00 00       	mov    $0xc,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sleep>:
SYSCALL(sleep)
 30b:	b8 0d 00 00 00       	mov    $0xd,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <uptime>:
SYSCALL(uptime)
 313:	b8 0e 00 00 00       	mov    $0xe,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <myfunction>:
SYSCALL(myfunction)
 31b:	b8 16 00 00 00       	mov    $0x16,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <yield>:
SYSCALL(yield)
 323:	b8 18 00 00 00       	mov    $0x18,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <getlev>:
SYSCALL(getlev)
 32b:	b8 19 00 00 00       	mov    $0x19,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <set_cpu_share>:
 333:	b8 1a 00 00 00       	mov    $0x1a,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    
 33b:	90                   	nop

0000033c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	57                   	push   %edi
 340:	56                   	push   %esi
 341:	53                   	push   %ebx
 342:	83 ec 3c             	sub    $0x3c,%esp
 345:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 347:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 349:	8b 5d 08             	mov    0x8(%ebp),%ebx
 34c:	85 db                	test   %ebx,%ebx
 34e:	74 04                	je     354 <printint+0x18>
 350:	85 d2                	test   %edx,%edx
 352:	78 5d                	js     3b1 <printint+0x75>
  neg = 0;
 354:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 356:	31 f6                	xor    %esi,%esi
 358:	eb 04                	jmp    35e <printint+0x22>
 35a:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 35c:	89 d6                	mov    %edx,%esi
 35e:	31 d2                	xor    %edx,%edx
 360:	f7 f1                	div    %ecx
 362:	8a 92 3c 07 00 00    	mov    0x73c(%edx),%dl
 368:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 36c:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 36f:	85 c0                	test   %eax,%eax
 371:	75 e9                	jne    35c <printint+0x20>
  if(neg)
 373:	85 db                	test   %ebx,%ebx
 375:	74 08                	je     37f <printint+0x43>
    buf[i++] = '-';
 377:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 37c:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 37f:	8d 5a ff             	lea    -0x1(%edx),%ebx
 382:	8d 75 d7             	lea    -0x29(%ebp),%esi
 385:	8d 76 00             	lea    0x0(%esi),%esi
 388:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 38c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 38f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 396:	00 
 397:	89 74 24 04          	mov    %esi,0x4(%esp)
 39b:	89 3c 24             	mov    %edi,(%esp)
 39e:	e8 f0 fe ff ff       	call   293 <write>
  while(--i >= 0)
 3a3:	4b                   	dec    %ebx
 3a4:	83 fb ff             	cmp    $0xffffffff,%ebx
 3a7:	75 df                	jne    388 <printint+0x4c>
    putc(fd, buf[i]);
}
 3a9:	83 c4 3c             	add    $0x3c,%esp
 3ac:	5b                   	pop    %ebx
 3ad:	5e                   	pop    %esi
 3ae:	5f                   	pop    %edi
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
    x = -xx;
 3b1:	f7 d8                	neg    %eax
    neg = 1;
 3b3:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 3b8:	eb 9c                	jmp    356 <printint+0x1a>
 3ba:	66 90                	xchg   %ax,%ax

000003bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	57                   	push   %edi
 3c0:	56                   	push   %esi
 3c1:	53                   	push   %ebx
 3c2:	83 ec 3c             	sub    $0x3c,%esp
 3c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3cb:	8a 03                	mov    (%ebx),%al
 3cd:	84 c0                	test   %al,%al
 3cf:	0f 84 bb 00 00 00    	je     490 <printf+0xd4>
printf(int fd, char *fmt, ...)
 3d5:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3d6:	8d 55 10             	lea    0x10(%ebp),%edx
 3d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 3dc:	31 ff                	xor    %edi,%edi
 3de:	eb 2f                	jmp    40f <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3e0:	83 f9 25             	cmp    $0x25,%ecx
 3e3:	0f 84 af 00 00 00    	je     498 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 3e9:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 3ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f3:	00 
 3f4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fb:	89 34 24             	mov    %esi,(%esp)
 3fe:	e8 90 fe ff ff       	call   293 <write>
 403:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 404:	8a 43 ff             	mov    -0x1(%ebx),%al
 407:	84 c0                	test   %al,%al
 409:	0f 84 81 00 00 00    	je     490 <printf+0xd4>
    c = fmt[i] & 0xff;
 40f:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 412:	85 ff                	test   %edi,%edi
 414:	74 ca                	je     3e0 <printf+0x24>
      }
    } else if(state == '%'){
 416:	83 ff 25             	cmp    $0x25,%edi
 419:	75 e8                	jne    403 <printf+0x47>
      if(c == 'd'){
 41b:	83 f9 64             	cmp    $0x64,%ecx
 41e:	0f 84 14 01 00 00    	je     538 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 424:	83 f9 78             	cmp    $0x78,%ecx
 427:	74 7b                	je     4a4 <printf+0xe8>
 429:	83 f9 70             	cmp    $0x70,%ecx
 42c:	74 76                	je     4a4 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 42e:	83 f9 73             	cmp    $0x73,%ecx
 431:	0f 84 91 00 00 00    	je     4c8 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 437:	83 f9 63             	cmp    $0x63,%ecx
 43a:	0f 84 cc 00 00 00    	je     50c <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 440:	83 f9 25             	cmp    $0x25,%ecx
 443:	0f 84 13 01 00 00    	je     55c <printf+0x1a0>
 449:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 44d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 454:	00 
 455:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	89 34 24             	mov    %esi,(%esp)
 45f:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 462:	e8 2c fe ff ff       	call   293 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 467:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 46a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 46d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 474:	00 
 475:	8d 55 e7             	lea    -0x19(%ebp),%edx
 478:	89 54 24 04          	mov    %edx,0x4(%esp)
 47c:	89 34 24             	mov    %esi,(%esp)
 47f:	e8 0f fe ff ff       	call   293 <write>
      }
      state = 0;
 484:	31 ff                	xor    %edi,%edi
 486:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 487:	8a 43 ff             	mov    -0x1(%ebx),%al
 48a:	84 c0                	test   %al,%al
 48c:	75 81                	jne    40f <printf+0x53>
 48e:	66 90                	xchg   %ax,%ax
    }
  }
}
 490:	83 c4 3c             	add    $0x3c,%esp
 493:	5b                   	pop    %ebx
 494:	5e                   	pop    %esi
 495:	5f                   	pop    %edi
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
        state = '%';
 498:	bf 25 00 00 00       	mov    $0x25,%edi
 49d:	e9 61 ff ff ff       	jmp    403 <printf+0x47>
 4a2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b3:	8b 10                	mov    (%eax),%edx
 4b5:	89 f0                	mov    %esi,%eax
 4b7:	e8 80 fe ff ff       	call   33c <printint>
        ap++;
 4bc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4c0:	31 ff                	xor    %edi,%edi
        ap++;
 4c2:	e9 3c ff ff ff       	jmp    403 <printf+0x47>
 4c7:	90                   	nop
        s = (char*)*ap;
 4c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4cb:	8b 3a                	mov    (%edx),%edi
        ap++;
 4cd:	83 c2 04             	add    $0x4,%edx
 4d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 4d3:	85 ff                	test   %edi,%edi
 4d5:	0f 84 a3 00 00 00    	je     57e <printf+0x1c2>
        while(*s != 0){
 4db:	8a 07                	mov    (%edi),%al
 4dd:	84 c0                	test   %al,%al
 4df:	74 24                	je     505 <printf+0x149>
 4e1:	8d 76 00             	lea    0x0(%esi),%esi
 4e4:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ee:	00 
 4ef:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 4f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f6:	89 34 24             	mov    %esi,(%esp)
 4f9:	e8 95 fd ff ff       	call   293 <write>
          s++;
 4fe:	47                   	inc    %edi
        while(*s != 0){
 4ff:	8a 07                	mov    (%edi),%al
 501:	84 c0                	test   %al,%al
 503:	75 df                	jne    4e4 <printf+0x128>
      state = 0;
 505:	31 ff                	xor    %edi,%edi
 507:	e9 f7 fe ff ff       	jmp    403 <printf+0x47>
        putc(fd, *ap);
 50c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 50f:	8b 02                	mov    (%edx),%eax
 511:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 514:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51b:	00 
 51c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 51f:	89 44 24 04          	mov    %eax,0x4(%esp)
 523:	89 34 24             	mov    %esi,(%esp)
 526:	e8 68 fd ff ff       	call   293 <write>
        ap++;
 52b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 52f:	31 ff                	xor    %edi,%edi
 531:	e9 cd fe ff ff       	jmp    403 <printf+0x47>
 536:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 53f:	b1 0a                	mov    $0xa,%cl
 541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 544:	8b 10                	mov    (%eax),%edx
 546:	89 f0                	mov    %esi,%eax
 548:	e8 ef fd ff ff       	call   33c <printint>
        ap++;
 54d:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 551:	66 31 ff             	xor    %di,%di
 554:	e9 aa fe ff ff       	jmp    403 <printf+0x47>
 559:	8d 76 00             	lea    0x0(%esi),%esi
 55c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 560:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 567:	00 
 568:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	89 34 24             	mov    %esi,(%esp)
 572:	e8 1c fd ff ff       	call   293 <write>
      state = 0;
 577:	31 ff                	xor    %edi,%edi
 579:	e9 85 fe ff ff       	jmp    403 <printf+0x47>
          s = "(null)";
 57e:	bf 35 07 00 00       	mov    $0x735,%edi
 583:	e9 53 ff ff ff       	jmp    4db <printf+0x11f>

00000588 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	57                   	push   %edi
 58c:	56                   	push   %esi
 58d:	53                   	push   %ebx
 58e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 591:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 594:	a1 d4 09 00 00       	mov    0x9d4,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 599:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59b:	39 d0                	cmp    %edx,%eax
 59d:	72 11                	jb     5b0 <free+0x28>
 59f:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a0:	39 c8                	cmp    %ecx,%eax
 5a2:	72 04                	jb     5a8 <free+0x20>
 5a4:	39 ca                	cmp    %ecx,%edx
 5a6:	72 10                	jb     5b8 <free+0x30>
 5a8:	89 c8                	mov    %ecx,%eax
 5aa:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ac:	39 d0                	cmp    %edx,%eax
 5ae:	73 f0                	jae    5a0 <free+0x18>
 5b0:	39 ca                	cmp    %ecx,%edx
 5b2:	72 04                	jb     5b8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b4:	39 c8                	cmp    %ecx,%eax
 5b6:	72 f0                	jb     5a8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5bb:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5be:	39 cf                	cmp    %ecx,%edi
 5c0:	74 1a                	je     5dc <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5c2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c5:	8b 48 04             	mov    0x4(%eax),%ecx
 5c8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5cb:	39 f2                	cmp    %esi,%edx
 5cd:	74 24                	je     5f3 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5cf:	89 10                	mov    %edx,(%eax)
  freep = p;
 5d1:	a3 d4 09 00 00       	mov    %eax,0x9d4
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    
 5db:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5dc:	03 71 04             	add    0x4(%ecx),%esi
 5df:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e2:	8b 08                	mov    (%eax),%ecx
 5e4:	8b 09                	mov    (%ecx),%ecx
 5e6:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e9:	8b 48 04             	mov    0x4(%eax),%ecx
 5ec:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5ef:	39 f2                	cmp    %esi,%edx
 5f1:	75 dc                	jne    5cf <free+0x47>
    p->s.size += bp->s.size;
 5f3:	03 4b fc             	add    -0x4(%ebx),%ecx
 5f6:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5f9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5fc:	89 10                	mov    %edx,(%eax)
  freep = p;
 5fe:	a3 d4 09 00 00       	mov    %eax,0x9d4
}
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    

00000608 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	57                   	push   %edi
 60c:	56                   	push   %esi
 60d:	53                   	push   %ebx
 60e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 611:	8b 75 08             	mov    0x8(%ebp),%esi
 614:	83 c6 07             	add    $0x7,%esi
 617:	c1 ee 03             	shr    $0x3,%esi
 61a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 61b:	8b 15 d4 09 00 00    	mov    0x9d4,%edx
 621:	85 d2                	test   %edx,%edx
 623:	0f 84 8d 00 00 00    	je     6b6 <malloc+0xae>
 629:	8b 02                	mov    (%edx),%eax
 62b:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 62e:	39 ce                	cmp    %ecx,%esi
 630:	76 52                	jbe    684 <malloc+0x7c>
 632:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 639:	eb 0a                	jmp    645 <malloc+0x3d>
 63b:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63e:	8b 48 04             	mov    0x4(%eax),%ecx
 641:	39 ce                	cmp    %ecx,%esi
 643:	76 3f                	jbe    684 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 645:	89 c2                	mov    %eax,%edx
 647:	3b 05 d4 09 00 00    	cmp    0x9d4,%eax
 64d:	75 ed                	jne    63c <malloc+0x34>
  if(nu < 4096)
 64f:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 655:	76 4d                	jbe    6a4 <malloc+0x9c>
 657:	89 d8                	mov    %ebx,%eax
 659:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 65b:	89 04 24             	mov    %eax,(%esp)
 65e:	e8 a0 fc ff ff       	call   303 <sbrk>
  if(p == (char*)-1)
 663:	83 f8 ff             	cmp    $0xffffffff,%eax
 666:	74 18                	je     680 <malloc+0x78>
  hp->s.size = nu;
 668:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 66b:	83 c0 08             	add    $0x8,%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 12 ff ff ff       	call   588 <free>
  return freep;
 676:	8b 15 d4 09 00 00    	mov    0x9d4,%edx
      if((p = morecore(nunits)) == 0)
 67c:	85 d2                	test   %edx,%edx
 67e:	75 bc                	jne    63c <malloc+0x34>
        return 0;
 680:	31 c0                	xor    %eax,%eax
 682:	eb 18                	jmp    69c <malloc+0x94>
      if(p->s.size == nunits)
 684:	39 ce                	cmp    %ecx,%esi
 686:	74 28                	je     6b0 <malloc+0xa8>
        p->s.size -= nunits;
 688:	29 f1                	sub    %esi,%ecx
 68a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 68d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 690:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 693:	89 15 d4 09 00 00    	mov    %edx,0x9d4
      return (void*)(p + 1);
 699:	83 c0 08             	add    $0x8,%eax
  }
}
 69c:	83 c4 1c             	add    $0x1c,%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
  if(nu < 4096)
 6a4:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 6a9:	bf 00 10 00 00       	mov    $0x1000,%edi
 6ae:	eb ab                	jmp    65b <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 6b0:	8b 08                	mov    (%eax),%ecx
 6b2:	89 0a                	mov    %ecx,(%edx)
 6b4:	eb dd                	jmp    693 <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 6b6:	c7 05 d4 09 00 00 d8 	movl   $0x9d8,0x9d4
 6bd:	09 00 00 
 6c0:	c7 05 d8 09 00 00 d8 	movl   $0x9d8,0x9d8
 6c7:	09 00 00 
    base.s.size = 0;
 6ca:	c7 05 dc 09 00 00 00 	movl   $0x0,0x9dc
 6d1:	00 00 00 
 6d4:	b8 d8 09 00 00       	mov    $0x9d8,%eax
 6d9:	e9 54 ff ff ff       	jmp    632 <malloc+0x2a>
