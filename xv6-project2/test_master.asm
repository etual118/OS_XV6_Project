
_test_master:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  {NAME_CHILD_MLFQ, "1", 0},
};

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
  int pid;
  int i;

  for (i = 0; i < CNT_CHILD; i++) {
   a:	31 db                	xor    %ebx,%ebx
    pid = fork();
   c:	e8 36 02 00 00       	call   247 <fork>
    if (pid > 0) {
  11:	83 f8 00             	cmp    $0x0,%eax
  14:	7e 1f                	jle    35 <main+0x35>
  for (i = 0; i < CNT_CHILD; i++) {
  16:	43                   	inc    %ebx
  17:	83 fb 04             	cmp    $0x4,%ebx
  1a:	75 f0                	jne    c <main+0xc>
      exit();
    }
  }
  
  for (i = 0; i < CNT_CHILD; i++) {
    wait();
  1c:	e8 36 02 00 00       	call   257 <wait>
  21:	e8 31 02 00 00       	call   257 <wait>
  26:	e8 2c 02 00 00       	call   257 <wait>
  2b:	e8 27 02 00 00       	call   257 <wait>
  }

  exit();
  30:	e8 1a 02 00 00       	call   24f <exit>
    } else if (pid == 0) {
  35:	75 34                	jne    6b <main+0x6b>
      exec(child_argv[i][0], child_argv[i]);
  37:	6b db 0c             	imul   $0xc,%ebx,%ebx
  3a:	8d 83 a0 09 00 00    	lea    0x9a0(%ebx),%eax
  40:	89 44 24 04          	mov    %eax,0x4(%esp)
  44:	8b 83 a0 09 00 00    	mov    0x9a0(%ebx),%eax
  4a:	89 04 24             	mov    %eax,(%esp)
  4d:	e8 35 02 00 00       	call   287 <exec>
      printf(1, "exec failed!!\n");
  52:	c7 44 24 04 ba 06 00 	movl   $0x6ba,0x4(%esp)
  59:	00 
  5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  61:	e8 32 03 00 00       	call   398 <printf>
      exit();
  66:	e8 e4 01 00 00       	call   24f <exit>
      printf(1, "fork failed!!\n");
  6b:	c7 44 24 04 c9 06 00 	movl   $0x6c9,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 19 03 00 00       	call   398 <printf>
      exit();
  7f:	e8 cb 01 00 00       	call   24f <exit>

00000084 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8e:	89 c2                	mov    %eax,%edx
  90:	8a 19                	mov    (%ecx),%bl
  92:	88 1a                	mov    %bl,(%edx)
  94:	42                   	inc    %edx
  95:	41                   	inc    %ecx
  96:	84 db                	test   %bl,%bl
  98:	75 f6                	jne    90 <strcpy+0xc>
    ;
  return os;
}
  9a:	5b                   	pop    %ebx
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    
  9d:	8d 76 00             	lea    0x0(%esi),%esi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	56                   	push   %esi
  a4:	53                   	push   %ebx
  a5:	8b 55 08             	mov    0x8(%ebp),%edx
  a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ab:	0f b6 02             	movzbl (%edx),%eax
  ae:	0f b6 19             	movzbl (%ecx),%ebx
  b1:	84 c0                	test   %al,%al
  b3:	75 14                	jne    c9 <strcmp+0x29>
  b5:	eb 1d                	jmp    d4 <strcmp+0x34>
  b7:	90                   	nop
    p++, q++;
  b8:	42                   	inc    %edx
  b9:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
  bc:	0f b6 02             	movzbl (%edx),%eax
  bf:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  c3:	84 c0                	test   %al,%al
  c5:	74 0d                	je     d4 <strcmp+0x34>
    p++, q++;
  c7:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
  c9:	38 d8                	cmp    %bl,%al
  cb:	74 eb                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  cd:	29 d8                	sub    %ebx,%eax
}
  cf:	5b                   	pop    %ebx
  d0:	5e                   	pop    %esi
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    
  d3:	90                   	nop
  while(*p && *p == *q)
  d4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  d6:	29 d8                	sub    %ebx,%eax
}
  d8:	5b                   	pop    %ebx
  d9:	5e                   	pop    %esi
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    

000000dc <strlen>:

uint
strlen(char *s)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e2:	80 39 00             	cmpb   $0x0,(%ecx)
  e5:	74 10                	je     f7 <strlen+0x1b>
  e7:	31 d2                	xor    %edx,%edx
  e9:	8d 76 00             	lea    0x0(%esi),%esi
  ec:	42                   	inc    %edx
  ed:	89 d0                	mov    %edx,%eax
  ef:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f3:	75 f7                	jne    ec <strlen+0x10>
    ;
  return n;
}
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  for(n = 0; s[n]; n++)
  f7:	31 c0                	xor    %eax,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    
  fb:	90                   	nop

000000fc <memset>:

void*
memset(void *dst, int c, uint n)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 103:	89 d7                	mov    %edx,%edi
 105:	8b 4d 10             	mov    0x10(%ebp),%ecx
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	fc                   	cld    
 10c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 10e:	89 d0                	mov    %edx,%eax
 110:	5f                   	pop    %edi
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    
 113:	90                   	nop

00000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 11d:	8a 10                	mov    (%eax),%dl
 11f:	84 d2                	test   %dl,%dl
 121:	75 0c                	jne    12f <strchr+0x1b>
 123:	eb 13                	jmp    138 <strchr+0x24>
 125:	8d 76 00             	lea    0x0(%esi),%esi
 128:	40                   	inc    %eax
 129:	8a 10                	mov    (%eax),%dl
 12b:	84 d2                	test   %dl,%dl
 12d:	74 09                	je     138 <strchr+0x24>
    if(*s == c)
 12f:	38 ca                	cmp    %cl,%dl
 131:	75 f5                	jne    128 <strchr+0x14>
      return (char*)s;
  return 0;
}
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    
 135:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 138:	31 c0                	xor    %eax,%eax
}
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	56                   	push   %esi
 141:	53                   	push   %ebx
 142:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 145:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 147:	8d 7d e7             	lea    -0x19(%ebp),%edi
 14a:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 14c:	8d 73 01             	lea    0x1(%ebx),%esi
 14f:	3b 75 0c             	cmp    0xc(%ebp),%esi
 152:	7d 40                	jge    194 <gets+0x58>
    cc = read(0, &c, 1);
 154:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 15b:	00 
 15c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 160:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 167:	e8 fb 00 00 00       	call   267 <read>
    if(cc < 1)
 16c:	85 c0                	test   %eax,%eax
 16e:	7e 24                	jle    194 <gets+0x58>
      break;
    buf[i++] = c;
 170:	8a 45 e7             	mov    -0x19(%ebp),%al
 173:	8b 55 08             	mov    0x8(%ebp),%edx
 176:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 06                	je     184 <gets+0x48>
 17e:	89 f3                	mov    %esi,%ebx
 180:	3c 0d                	cmp    $0xd,%al
 182:	75 c8                	jne    14c <gets+0x10>
      break;
  }
  buf[i] = '\0';
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 18b:	83 c4 2c             	add    $0x2c,%esp
 18e:	5b                   	pop    %ebx
 18f:	5e                   	pop    %esi
 190:	5f                   	pop    %edi
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	90                   	nop
    if(cc < 1)
 194:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 19d:	83 c4 2c             	add    $0x2c,%esp
 1a0:	5b                   	pop    %ebx
 1a1:	5e                   	pop    %esi
 1a2:	5f                   	pop    %edi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 76 00             	lea    0x0(%esi),%esi

000001a8 <stat>:

int
stat(char *n, struct stat *st)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	56                   	push   %esi
 1ac:	53                   	push   %ebx
 1ad:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b7:	00 
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	89 04 24             	mov    %eax,(%esp)
 1be:	e8 cc 00 00 00       	call   28f <open>
 1c3:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1c5:	85 c0                	test   %eax,%eax
 1c7:	78 23                	js     1ec <stat+0x44>
    return -1;
  r = fstat(fd, st);
 1c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d0:	89 1c 24             	mov    %ebx,(%esp)
 1d3:	e8 cf 00 00 00       	call   2a7 <fstat>
 1d8:	89 c6                	mov    %eax,%esi
  close(fd);
 1da:	89 1c 24             	mov    %ebx,(%esp)
 1dd:	e8 95 00 00 00       	call   277 <close>
  return r;
}
 1e2:	89 f0                	mov    %esi,%eax
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	5b                   	pop    %ebx
 1e8:	5e                   	pop    %esi
 1e9:	5d                   	pop    %ebp
 1ea:	c3                   	ret    
 1eb:	90                   	nop
    return -1;
 1ec:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f1:	eb ef                	jmp    1e2 <stat+0x3a>
 1f3:	90                   	nop

000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	53                   	push   %ebx
 1f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fb:	0f be 11             	movsbl (%ecx),%edx
 1fe:	8d 42 d0             	lea    -0x30(%edx),%eax
 201:	3c 09                	cmp    $0x9,%al
 203:	b8 00 00 00 00       	mov    $0x0,%eax
 208:	77 15                	ja     21f <atoi+0x2b>
 20a:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 20c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 20f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 213:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 214:	0f be 11             	movsbl (%ecx),%edx
 217:	8d 5a d0             	lea    -0x30(%edx),%ebx
 21a:	80 fb 09             	cmp    $0x9,%bl
 21d:	76 ed                	jbe    20c <atoi+0x18>
  return n;
}
 21f:	5b                   	pop    %ebx
 220:	5d                   	pop    %ebp
 221:	c3                   	ret    
 222:	66 90                	xchg   %ax,%ax

00000224 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	56                   	push   %esi
 228:	53                   	push   %ebx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 22f:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 232:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 234:	85 f6                	test   %esi,%esi
 236:	7e 0b                	jle    243 <memmove+0x1f>
    *dst++ = *src++;
 238:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 23b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 23e:	42                   	inc    %edx
  while(n-- > 0)
 23f:	39 f2                	cmp    %esi,%edx
 241:	75 f5                	jne    238 <memmove+0x14>
  return vdst;
}
 243:	5b                   	pop    %ebx
 244:	5e                   	pop    %esi
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 247:	b8 01 00 00 00       	mov    $0x1,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <exit>:
SYSCALL(exit)
 24f:	b8 02 00 00 00       	mov    $0x2,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <wait>:
SYSCALL(wait)
 257:	b8 03 00 00 00       	mov    $0x3,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <pipe>:
SYSCALL(pipe)
 25f:	b8 04 00 00 00       	mov    $0x4,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <read>:
SYSCALL(read)
 267:	b8 05 00 00 00       	mov    $0x5,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <write>:
SYSCALL(write)
 26f:	b8 10 00 00 00       	mov    $0x10,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <close>:
SYSCALL(close)
 277:	b8 15 00 00 00       	mov    $0x15,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <kill>:
SYSCALL(kill)
 27f:	b8 06 00 00 00       	mov    $0x6,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <exec>:
SYSCALL(exec)
 287:	b8 07 00 00 00       	mov    $0x7,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <open>:
SYSCALL(open)
 28f:	b8 0f 00 00 00       	mov    $0xf,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <mknod>:
SYSCALL(mknod)
 297:	b8 11 00 00 00       	mov    $0x11,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <unlink>:
SYSCALL(unlink)
 29f:	b8 12 00 00 00       	mov    $0x12,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <fstat>:
SYSCALL(fstat)
 2a7:	b8 08 00 00 00       	mov    $0x8,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <link>:
SYSCALL(link)
 2af:	b8 13 00 00 00       	mov    $0x13,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <mkdir>:
SYSCALL(mkdir)
 2b7:	b8 14 00 00 00       	mov    $0x14,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <chdir>:
SYSCALL(chdir)
 2bf:	b8 09 00 00 00       	mov    $0x9,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <dup>:
SYSCALL(dup)
 2c7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <getpid>:
SYSCALL(getpid)
 2cf:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <getppid>:
SYSCALL(getppid)
 2d7:	b8 17 00 00 00       	mov    $0x17,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <sbrk>:
SYSCALL(sbrk)
 2df:	b8 0c 00 00 00       	mov    $0xc,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <sleep>:
SYSCALL(sleep)
 2e7:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <uptime>:
SYSCALL(uptime)
 2ef:	b8 0e 00 00 00       	mov    $0xe,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <myfunction>:
SYSCALL(myfunction)
 2f7:	b8 16 00 00 00       	mov    $0x16,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <yield>:
SYSCALL(yield)
 2ff:	b8 18 00 00 00       	mov    $0x18,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <getlev>:
SYSCALL(getlev)
 307:	b8 19 00 00 00       	mov    $0x19,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <set_cpu_share>:
 30f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    
 317:	90                   	nop

00000318 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	57                   	push   %edi
 31c:	56                   	push   %esi
 31d:	53                   	push   %ebx
 31e:	83 ec 3c             	sub    $0x3c,%esp
 321:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 323:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 325:	8b 5d 08             	mov    0x8(%ebp),%ebx
 328:	85 db                	test   %ebx,%ebx
 32a:	74 04                	je     330 <printint+0x18>
 32c:	85 d2                	test   %edx,%edx
 32e:	78 5d                	js     38d <printint+0x75>
  neg = 0;
 330:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 332:	31 f6                	xor    %esi,%esi
 334:	eb 04                	jmp    33a <printint+0x22>
 336:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 338:	89 d6                	mov    %edx,%esi
 33a:	31 d2                	xor    %edx,%edx
 33c:	f7 f1                	div    %ecx
 33e:	8a 92 fd 06 00 00    	mov    0x6fd(%edx),%dl
 344:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 348:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 34b:	85 c0                	test   %eax,%eax
 34d:	75 e9                	jne    338 <printint+0x20>
  if(neg)
 34f:	85 db                	test   %ebx,%ebx
 351:	74 08                	je     35b <printint+0x43>
    buf[i++] = '-';
 353:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 358:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 35b:	8d 5a ff             	lea    -0x1(%edx),%ebx
 35e:	8d 75 d7             	lea    -0x29(%ebp),%esi
 361:	8d 76 00             	lea    0x0(%esi),%esi
 364:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 368:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 36b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 372:	00 
 373:	89 74 24 04          	mov    %esi,0x4(%esp)
 377:	89 3c 24             	mov    %edi,(%esp)
 37a:	e8 f0 fe ff ff       	call   26f <write>
  while(--i >= 0)
 37f:	4b                   	dec    %ebx
 380:	83 fb ff             	cmp    $0xffffffff,%ebx
 383:	75 df                	jne    364 <printint+0x4c>
    putc(fd, buf[i]);
}
 385:	83 c4 3c             	add    $0x3c,%esp
 388:	5b                   	pop    %ebx
 389:	5e                   	pop    %esi
 38a:	5f                   	pop    %edi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
    x = -xx;
 38d:	f7 d8                	neg    %eax
    neg = 1;
 38f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 394:	eb 9c                	jmp    332 <printint+0x1a>
 396:	66 90                	xchg   %ax,%ax

00000398 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	57                   	push   %edi
 39c:	56                   	push   %esi
 39d:	53                   	push   %ebx
 39e:	83 ec 3c             	sub    $0x3c,%esp
 3a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3a7:	8a 03                	mov    (%ebx),%al
 3a9:	84 c0                	test   %al,%al
 3ab:	0f 84 bb 00 00 00    	je     46c <printf+0xd4>
printf(int fd, char *fmt, ...)
 3b1:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3b2:	8d 55 10             	lea    0x10(%ebp),%edx
 3b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 3b8:	31 ff                	xor    %edi,%edi
 3ba:	eb 2f                	jmp    3eb <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3bc:	83 f9 25             	cmp    $0x25,%ecx
 3bf:	0f 84 af 00 00 00    	je     474 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 3c5:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 3c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3cf:	00 
 3d0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d7:	89 34 24             	mov    %esi,(%esp)
 3da:	e8 90 fe ff ff       	call   26f <write>
 3df:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 3e0:	8a 43 ff             	mov    -0x1(%ebx),%al
 3e3:	84 c0                	test   %al,%al
 3e5:	0f 84 81 00 00 00    	je     46c <printf+0xd4>
    c = fmt[i] & 0xff;
 3eb:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 3ee:	85 ff                	test   %edi,%edi
 3f0:	74 ca                	je     3bc <printf+0x24>
      }
    } else if(state == '%'){
 3f2:	83 ff 25             	cmp    $0x25,%edi
 3f5:	75 e8                	jne    3df <printf+0x47>
      if(c == 'd'){
 3f7:	83 f9 64             	cmp    $0x64,%ecx
 3fa:	0f 84 14 01 00 00    	je     514 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 400:	83 f9 78             	cmp    $0x78,%ecx
 403:	74 7b                	je     480 <printf+0xe8>
 405:	83 f9 70             	cmp    $0x70,%ecx
 408:	74 76                	je     480 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 40a:	83 f9 73             	cmp    $0x73,%ecx
 40d:	0f 84 91 00 00 00    	je     4a4 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 413:	83 f9 63             	cmp    $0x63,%ecx
 416:	0f 84 cc 00 00 00    	je     4e8 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 41c:	83 f9 25             	cmp    $0x25,%ecx
 41f:	0f 84 13 01 00 00    	je     538 <printf+0x1a0>
 425:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 429:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 430:	00 
 431:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	89 34 24             	mov    %esi,(%esp)
 43b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 43e:	e8 2c fe ff ff       	call   26f <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 443:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 446:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 449:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 450:	00 
 451:	8d 55 e7             	lea    -0x19(%ebp),%edx
 454:	89 54 24 04          	mov    %edx,0x4(%esp)
 458:	89 34 24             	mov    %esi,(%esp)
 45b:	e8 0f fe ff ff       	call   26f <write>
      }
      state = 0;
 460:	31 ff                	xor    %edi,%edi
 462:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 463:	8a 43 ff             	mov    -0x1(%ebx),%al
 466:	84 c0                	test   %al,%al
 468:	75 81                	jne    3eb <printf+0x53>
 46a:	66 90                	xchg   %ax,%ax
    }
  }
}
 46c:	83 c4 3c             	add    $0x3c,%esp
 46f:	5b                   	pop    %ebx
 470:	5e                   	pop    %esi
 471:	5f                   	pop    %edi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
        state = '%';
 474:	bf 25 00 00 00       	mov    $0x25,%edi
 479:	e9 61 ff ff ff       	jmp    3df <printf+0x47>
 47e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 487:	b9 10 00 00 00       	mov    $0x10,%ecx
 48c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 48f:	8b 10                	mov    (%eax),%edx
 491:	89 f0                	mov    %esi,%eax
 493:	e8 80 fe ff ff       	call   318 <printint>
        ap++;
 498:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 49c:	31 ff                	xor    %edi,%edi
        ap++;
 49e:	e9 3c ff ff ff       	jmp    3df <printf+0x47>
 4a3:	90                   	nop
        s = (char*)*ap;
 4a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a7:	8b 3a                	mov    (%edx),%edi
        ap++;
 4a9:	83 c2 04             	add    $0x4,%edx
 4ac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 4af:	85 ff                	test   %edi,%edi
 4b1:	0f 84 a3 00 00 00    	je     55a <printf+0x1c2>
        while(*s != 0){
 4b7:	8a 07                	mov    (%edi),%al
 4b9:	84 c0                	test   %al,%al
 4bb:	74 24                	je     4e1 <printf+0x149>
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
 4c0:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ca:	00 
 4cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d2:	89 34 24             	mov    %esi,(%esp)
 4d5:	e8 95 fd ff ff       	call   26f <write>
          s++;
 4da:	47                   	inc    %edi
        while(*s != 0){
 4db:	8a 07                	mov    (%edi),%al
 4dd:	84 c0                	test   %al,%al
 4df:	75 df                	jne    4c0 <printf+0x128>
      state = 0;
 4e1:	31 ff                	xor    %edi,%edi
 4e3:	e9 f7 fe ff ff       	jmp    3df <printf+0x47>
        putc(fd, *ap);
 4e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4eb:	8b 02                	mov    (%edx),%eax
 4ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 4f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f7:	00 
 4f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	89 34 24             	mov    %esi,(%esp)
 502:	e8 68 fd ff ff       	call   26f <write>
        ap++;
 507:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 50b:	31 ff                	xor    %edi,%edi
 50d:	e9 cd fe ff ff       	jmp    3df <printf+0x47>
 512:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 51b:	b1 0a                	mov    $0xa,%cl
 51d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 520:	8b 10                	mov    (%eax),%edx
 522:	89 f0                	mov    %esi,%eax
 524:	e8 ef fd ff ff       	call   318 <printint>
        ap++;
 529:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 52d:	66 31 ff             	xor    %di,%di
 530:	e9 aa fe ff ff       	jmp    3df <printf+0x47>
 535:	8d 76 00             	lea    0x0(%esi),%esi
 538:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 53c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 543:	00 
 544:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 547:	89 44 24 04          	mov    %eax,0x4(%esp)
 54b:	89 34 24             	mov    %esi,(%esp)
 54e:	e8 1c fd ff ff       	call   26f <write>
      state = 0;
 553:	31 ff                	xor    %edi,%edi
 555:	e9 85 fe ff ff       	jmp    3df <printf+0x47>
          s = "(null)";
 55a:	bf f6 06 00 00       	mov    $0x6f6,%edi
 55f:	e9 53 ff ff ff       	jmp    4b7 <printf+0x11f>

00000564 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	53                   	push   %ebx
 56a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 56d:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 570:	a1 d0 09 00 00       	mov    0x9d0,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 575:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 577:	39 d0                	cmp    %edx,%eax
 579:	72 11                	jb     58c <free+0x28>
 57b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 57c:	39 c8                	cmp    %ecx,%eax
 57e:	72 04                	jb     584 <free+0x20>
 580:	39 ca                	cmp    %ecx,%edx
 582:	72 10                	jb     594 <free+0x30>
 584:	89 c8                	mov    %ecx,%eax
 586:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 588:	39 d0                	cmp    %edx,%eax
 58a:	73 f0                	jae    57c <free+0x18>
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	72 04                	jb     594 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 c8                	cmp    %ecx,%eax
 592:	72 f0                	jb     584 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 594:	8b 73 fc             	mov    -0x4(%ebx),%esi
 597:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 59a:	39 cf                	cmp    %ecx,%edi
 59c:	74 1a                	je     5b8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 59e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a1:	8b 48 04             	mov    0x4(%eax),%ecx
 5a4:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5a7:	39 f2                	cmp    %esi,%edx
 5a9:	74 24                	je     5cf <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 5ad:	a3 d0 09 00 00       	mov    %eax,0x9d0
}
 5b2:	5b                   	pop    %ebx
 5b3:	5e                   	pop    %esi
 5b4:	5f                   	pop    %edi
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5b8:	03 71 04             	add    0x4(%ecx),%esi
 5bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5be:	8b 08                	mov    (%eax),%ecx
 5c0:	8b 09                	mov    (%ecx),%ecx
 5c2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5c5:	8b 48 04             	mov    0x4(%eax),%ecx
 5c8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5cb:	39 f2                	cmp    %esi,%edx
 5cd:	75 dc                	jne    5ab <free+0x47>
    p->s.size += bp->s.size;
 5cf:	03 4b fc             	add    -0x4(%ebx),%ecx
 5d2:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5d5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5d8:	89 10                	mov    %edx,(%eax)
  freep = p;
 5da:	a3 d0 09 00 00       	mov    %eax,0x9d0
}
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    

000005e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	57                   	push   %edi
 5e8:	56                   	push   %esi
 5e9:	53                   	push   %ebx
 5ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ed:	8b 75 08             	mov    0x8(%ebp),%esi
 5f0:	83 c6 07             	add    $0x7,%esi
 5f3:	c1 ee 03             	shr    $0x3,%esi
 5f6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5f7:	8b 15 d0 09 00 00    	mov    0x9d0,%edx
 5fd:	85 d2                	test   %edx,%edx
 5ff:	0f 84 8d 00 00 00    	je     692 <malloc+0xae>
 605:	8b 02                	mov    (%edx),%eax
 607:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 60a:	39 ce                	cmp    %ecx,%esi
 60c:	76 52                	jbe    660 <malloc+0x7c>
 60e:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 615:	eb 0a                	jmp    621 <malloc+0x3d>
 617:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 618:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 61a:	8b 48 04             	mov    0x4(%eax),%ecx
 61d:	39 ce                	cmp    %ecx,%esi
 61f:	76 3f                	jbe    660 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 621:	89 c2                	mov    %eax,%edx
 623:	3b 05 d0 09 00 00    	cmp    0x9d0,%eax
 629:	75 ed                	jne    618 <malloc+0x34>
  if(nu < 4096)
 62b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 631:	76 4d                	jbe    680 <malloc+0x9c>
 633:	89 d8                	mov    %ebx,%eax
 635:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 a0 fc ff ff       	call   2df <sbrk>
  if(p == (char*)-1)
 63f:	83 f8 ff             	cmp    $0xffffffff,%eax
 642:	74 18                	je     65c <malloc+0x78>
  hp->s.size = nu;
 644:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 647:	83 c0 08             	add    $0x8,%eax
 64a:	89 04 24             	mov    %eax,(%esp)
 64d:	e8 12 ff ff ff       	call   564 <free>
  return freep;
 652:	8b 15 d0 09 00 00    	mov    0x9d0,%edx
      if((p = morecore(nunits)) == 0)
 658:	85 d2                	test   %edx,%edx
 65a:	75 bc                	jne    618 <malloc+0x34>
        return 0;
 65c:	31 c0                	xor    %eax,%eax
 65e:	eb 18                	jmp    678 <malloc+0x94>
      if(p->s.size == nunits)
 660:	39 ce                	cmp    %ecx,%esi
 662:	74 28                	je     68c <malloc+0xa8>
        p->s.size -= nunits;
 664:	29 f1                	sub    %esi,%ecx
 666:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 669:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 66c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 66f:	89 15 d0 09 00 00    	mov    %edx,0x9d0
      return (void*)(p + 1);
 675:	83 c0 08             	add    $0x8,%eax
  }
}
 678:	83 c4 1c             	add    $0x1c,%esp
 67b:	5b                   	pop    %ebx
 67c:	5e                   	pop    %esi
 67d:	5f                   	pop    %edi
 67e:	5d                   	pop    %ebp
 67f:	c3                   	ret    
  if(nu < 4096)
 680:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 685:	bf 00 10 00 00       	mov    $0x1000,%edi
 68a:	eb ab                	jmp    637 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 68c:	8b 08                	mov    (%eax),%ecx
 68e:	89 0a                	mov    %ecx,(%edx)
 690:	eb dd                	jmp    66f <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 692:	c7 05 d0 09 00 00 d4 	movl   $0x9d4,0x9d0
 699:	09 00 00 
 69c:	c7 05 d4 09 00 00 d4 	movl   $0x9d4,0x9d4
 6a3:	09 00 00 
    base.s.size = 0;
 6a6:	c7 05 d8 09 00 00 00 	movl   $0x0,0x9d8
 6ad:	00 00 00 
 6b0:	b8 d4 09 00 00       	mov    $0x9d4,%eax
 6b5:	e9 54 ff ff ff       	jmp    60e <malloc+0x2a>
