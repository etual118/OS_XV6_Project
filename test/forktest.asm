
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 31 00 00 00       	call   3c <forktest>
  exit();
   b:	e8 b7 02 00 00       	call   2c7 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 14             	sub    $0x14,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	89 1c 24             	mov    %ebx,(%esp)
  1d:	e8 32 01 00 00       	call   154 <strlen>
  22:	89 44 24 08          	mov    %eax,0x8(%esp)
  26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  2a:	8b 45 08             	mov    0x8(%ebp),%eax
  2d:	89 04 24             	mov    %eax,(%esp)
  30:	e8 b2 02 00 00       	call   2e7 <write>
}
  35:	83 c4 14             	add    $0x14,%esp
  38:	5b                   	pop    %ebx
  39:	5d                   	pop    %ebp
  3a:	c3                   	ret    
  3b:	90                   	nop

0000003c <forktest>:
{
  3c:	55                   	push   %ebp
  3d:	89 e5                	mov    %esp,%ebp
  3f:	53                   	push   %ebx
  40:	83 ec 14             	sub    $0x14,%esp
  printf(1, "fork test\n");
  43:	c7 44 24 04 90 03 00 	movl   $0x390,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 b9 ff ff ff       	call   10 <printf>
  for(n=0; n<N; n++){
  57:	31 db                	xor    %ebx,%ebx
  59:	eb 0c                	jmp    67 <forktest+0x2b>
  5b:	90                   	nop
    if(pid == 0)
  5c:	74 7f                	je     dd <forktest+0xa1>
  for(n=0; n<N; n++){
  5e:	43                   	inc    %ebx
  5f:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  65:	74 41                	je     a8 <forktest+0x6c>
    pid = fork();
  67:	e8 53 02 00 00       	call   2bf <fork>
    if(pid < 0)
  6c:	83 f8 00             	cmp    $0x0,%eax
  6f:	7d eb                	jge    5c <forktest+0x20>
  for(; n > 0; n--){
  71:	85 db                	test   %ebx,%ebx
  73:	74 0f                	je     84 <forktest+0x48>
  75:	8d 76 00             	lea    0x0(%esi),%esi
    if(wait() < 0){
  78:	e8 52 02 00 00       	call   2cf <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	78 48                	js     c9 <forktest+0x8d>
  for(; n > 0; n--){
  81:	4b                   	dec    %ebx
  82:	75 f4                	jne    78 <forktest+0x3c>
  if(wait() != -1){
  84:	e8 46 02 00 00       	call   2cf <wait>
  89:	40                   	inc    %eax
  8a:	75 56                	jne    e2 <forktest+0xa6>
  printf(1, "fork test OK\n");
  8c:	c7 44 24 04 c2 03 00 	movl   $0x3c2,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 70 ff ff ff       	call   10 <printf>
}
  a0:	83 c4 14             	add    $0x14,%esp
  a3:	5b                   	pop    %ebx
  a4:	5d                   	pop    %ebp
  a5:	c3                   	ret    
  a6:	66 90                	xchg   %ax,%ax
    printf(1, "fork claimed to work N times!\n", N);
  a8:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  af:	00 
  b0:	c7 44 24 04 d0 03 00 	movl   $0x3d0,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bf:	e8 4c ff ff ff       	call   10 <printf>
    exit();
  c4:	e8 fe 01 00 00       	call   2c7 <exit>
      printf(1, "wait stopped early\n");
  c9:	c7 44 24 04 9b 03 00 	movl   $0x39b,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 33 ff ff ff       	call   10 <printf>
      exit();
  dd:	e8 e5 01 00 00       	call   2c7 <exit>
    printf(1, "wait got too many\n");
  e2:	c7 44 24 04 af 03 00 	movl   $0x3af,0x4(%esp)
  e9:	00 
  ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f1:	e8 1a ff ff ff       	call   10 <printf>
    exit();
  f6:	e8 cc 01 00 00       	call   2c7 <exit>
  fb:	90                   	nop

000000fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	53                   	push   %ebx
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 106:	89 c2                	mov    %eax,%edx
 108:	8a 19                	mov    (%ecx),%bl
 10a:	88 1a                	mov    %bl,(%edx)
 10c:	42                   	inc    %edx
 10d:	41                   	inc    %ecx
 10e:	84 db                	test   %bl,%bl
 110:	75 f6                	jne    108 <strcpy+0xc>
    ;
  return os;
}
 112:	5b                   	pop    %ebx
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
 115:	8d 76 00             	lea    0x0(%esi),%esi

00000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	56                   	push   %esi
 11c:	53                   	push   %ebx
 11d:	8b 55 08             	mov    0x8(%ebp),%edx
 120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 123:	0f b6 02             	movzbl (%edx),%eax
 126:	0f b6 19             	movzbl (%ecx),%ebx
 129:	84 c0                	test   %al,%al
 12b:	75 14                	jne    141 <strcmp+0x29>
 12d:	eb 1d                	jmp    14c <strcmp+0x34>
 12f:	90                   	nop
    p++, q++;
 130:	42                   	inc    %edx
 131:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 134:	0f b6 02             	movzbl (%edx),%eax
 137:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 13b:	84 c0                	test   %al,%al
 13d:	74 0d                	je     14c <strcmp+0x34>
    p++, q++;
 13f:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 141:	38 d8                	cmp    %bl,%al
 143:	74 eb                	je     130 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 145:	29 d8                	sub    %ebx,%eax
}
 147:	5b                   	pop    %ebx
 148:	5e                   	pop    %esi
 149:	5d                   	pop    %ebp
 14a:	c3                   	ret    
 14b:	90                   	nop
  while(*p && *p == *q)
 14c:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 14e:	29 d8                	sub    %ebx,%eax
}
 150:	5b                   	pop    %ebx
 151:	5e                   	pop    %esi
 152:	5d                   	pop    %ebp
 153:	c3                   	ret    

00000154 <strlen>:

uint
strlen(char *s)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 15a:	80 39 00             	cmpb   $0x0,(%ecx)
 15d:	74 10                	je     16f <strlen+0x1b>
 15f:	31 d2                	xor    %edx,%edx
 161:	8d 76 00             	lea    0x0(%esi),%esi
 164:	42                   	inc    %edx
 165:	89 d0                	mov    %edx,%eax
 167:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 16b:	75 f7                	jne    164 <strlen+0x10>
    ;
  return n;
}
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    
  for(n = 0; s[n]; n++)
 16f:	31 c0                	xor    %eax,%eax
}
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	90                   	nop

00000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 17b:	89 d7                	mov    %edx,%edi
 17d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	fc                   	cld    
 184:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 186:	89 d0                	mov    %edx,%eax
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop

0000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 195:	8a 10                	mov    (%eax),%dl
 197:	84 d2                	test   %dl,%dl
 199:	75 0c                	jne    1a7 <strchr+0x1b>
 19b:	eb 13                	jmp    1b0 <strchr+0x24>
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	40                   	inc    %eax
 1a1:	8a 10                	mov    (%eax),%dl
 1a3:	84 d2                	test   %dl,%dl
 1a5:	74 09                	je     1b0 <strchr+0x24>
    if(*s == c)
 1a7:	38 ca                	cmp    %cl,%dl
 1a9:	75 f5                	jne    1a0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bd:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1bf:	8d 7d e7             	lea    -0x19(%ebp),%edi
 1c2:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 1c4:	8d 73 01             	lea    0x1(%ebx),%esi
 1c7:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1ca:	7d 40                	jge    20c <gets+0x58>
    cc = read(0, &c, 1);
 1cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d3:	00 
 1d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1df:	e8 fb 00 00 00       	call   2df <read>
    if(cc < 1)
 1e4:	85 c0                	test   %eax,%eax
 1e6:	7e 24                	jle    20c <gets+0x58>
      break;
    buf[i++] = c;
 1e8:	8a 45 e7             	mov    -0x19(%ebp),%al
 1eb:	8b 55 08             	mov    0x8(%ebp),%edx
 1ee:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 1f2:	3c 0a                	cmp    $0xa,%al
 1f4:	74 06                	je     1fc <gets+0x48>
 1f6:	89 f3                	mov    %esi,%ebx
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	75 c8                	jne    1c4 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 203:	83 c4 2c             	add    $0x2c,%esp
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    
 20b:	90                   	nop
    if(cc < 1)
 20c:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 215:	83 c4 2c             	add    $0x2c,%esp
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5f                   	pop    %edi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 22f:	00 
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 cc 00 00 00       	call   307 <open>
 23b:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 23d:	85 c0                	test   %eax,%eax
 23f:	78 23                	js     264 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	89 44 24 04          	mov    %eax,0x4(%esp)
 248:	89 1c 24             	mov    %ebx,(%esp)
 24b:	e8 cf 00 00 00       	call   31f <fstat>
 250:	89 c6                	mov    %eax,%esi
  close(fd);
 252:	89 1c 24             	mov    %ebx,(%esp)
 255:	e8 95 00 00 00       	call   2ef <close>
  return r;
}
 25a:	89 f0                	mov    %esi,%eax
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	5b                   	pop    %ebx
 260:	5e                   	pop    %esi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	90                   	nop
    return -1;
 264:	be ff ff ff ff       	mov    $0xffffffff,%esi
 269:	eb ef                	jmp    25a <stat+0x3a>
 26b:	90                   	nop

0000026c <atoi>:

int
atoi(const char *s)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	53                   	push   %ebx
 270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 273:	0f be 11             	movsbl (%ecx),%edx
 276:	8d 42 d0             	lea    -0x30(%edx),%eax
 279:	3c 09                	cmp    $0x9,%al
 27b:	b8 00 00 00 00       	mov    $0x0,%eax
 280:	77 15                	ja     297 <atoi+0x2b>
 282:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 284:	8d 04 80             	lea    (%eax,%eax,4),%eax
 287:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 28b:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 28c:	0f be 11             	movsbl (%ecx),%edx
 28f:	8d 5a d0             	lea    -0x30(%edx),%ebx
 292:	80 fb 09             	cmp    $0x9,%bl
 295:	76 ed                	jbe    284 <atoi+0x18>
  return n;
}
 297:	5b                   	pop    %ebx
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
 29a:	66 90                	xchg   %ax,%ax

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	56                   	push   %esi
 2a0:	53                   	push   %ebx
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2a7:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 2aa:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ac:	85 f6                	test   %esi,%esi
 2ae:	7e 0b                	jle    2bb <memmove+0x1f>
    *dst++ = *src++;
 2b0:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 2b3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2b6:	42                   	inc    %edx
  while(n-- > 0)
 2b7:	39 f2                	cmp    %esi,%edx
 2b9:	75 f5                	jne    2b0 <memmove+0x14>
  return vdst;
}
 2bb:	5b                   	pop    %ebx
 2bc:	5e                   	pop    %esi
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    

000002bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bf:	b8 01 00 00 00       	mov    $0x1,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <exit>:
SYSCALL(exit)
 2c7:	b8 02 00 00 00       	mov    $0x2,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <wait>:
SYSCALL(wait)
 2cf:	b8 03 00 00 00       	mov    $0x3,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <pipe>:
SYSCALL(pipe)
 2d7:	b8 04 00 00 00       	mov    $0x4,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <read>:
SYSCALL(read)
 2df:	b8 05 00 00 00       	mov    $0x5,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <write>:
SYSCALL(write)
 2e7:	b8 10 00 00 00       	mov    $0x10,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <close>:
SYSCALL(close)
 2ef:	b8 15 00 00 00       	mov    $0x15,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <kill>:
SYSCALL(kill)
 2f7:	b8 06 00 00 00       	mov    $0x6,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exec>:
SYSCALL(exec)
 2ff:	b8 07 00 00 00       	mov    $0x7,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <open>:
SYSCALL(open)
 307:	b8 0f 00 00 00       	mov    $0xf,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mknod>:
SYSCALL(mknod)
 30f:	b8 11 00 00 00       	mov    $0x11,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <unlink>:
SYSCALL(unlink)
 317:	b8 12 00 00 00       	mov    $0x12,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <fstat>:
SYSCALL(fstat)
 31f:	b8 08 00 00 00       	mov    $0x8,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <link>:
SYSCALL(link)
 327:	b8 13 00 00 00       	mov    $0x13,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mkdir>:
SYSCALL(mkdir)
 32f:	b8 14 00 00 00       	mov    $0x14,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <chdir>:
SYSCALL(chdir)
 337:	b8 09 00 00 00       	mov    $0x9,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <dup>:
SYSCALL(dup)
 33f:	b8 0a 00 00 00       	mov    $0xa,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <getpid>:
SYSCALL(getpid)
 347:	b8 0b 00 00 00       	mov    $0xb,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <getppid>:
SYSCALL(getppid)
 34f:	b8 17 00 00 00       	mov    $0x17,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sbrk>:
SYSCALL(sbrk)
 357:	b8 0c 00 00 00       	mov    $0xc,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sleep>:
SYSCALL(sleep)
 35f:	b8 0d 00 00 00       	mov    $0xd,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <uptime>:
SYSCALL(uptime)
 367:	b8 0e 00 00 00       	mov    $0xe,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <myfunction>:
SYSCALL(myfunction)
 36f:	b8 16 00 00 00       	mov    $0x16,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <yield>:
SYSCALL(yield)
 377:	b8 18 00 00 00       	mov    $0x18,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <getlev>:
SYSCALL(getlev)
 37f:	b8 19 00 00 00       	mov    $0x19,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <set_cpu_share>:
 387:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    
