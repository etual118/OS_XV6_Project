
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 20             	sub    $0x20,%esp
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 66                	jle    7a <main+0x7a>
main(int argc, char *argv[])
  14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  17:	83 c3 04             	add    $0x4,%ebx
  1a:	be 01 00 00 00       	mov    $0x1,%esi
  1f:	90                   	nop
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  27:	00 
  28:	8b 03                	mov    (%ebx),%eax
  2a:	89 04 24             	mov    %eax,(%esp)
  2d:	e8 ed 02 00 00       	call   31f <open>
  32:	85 c0                	test   %eax,%eax
  34:	78 25                	js     5b <main+0x5b>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  36:	89 04 24             	mov    %eax,(%esp)
  39:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  3d:	e8 4a 00 00 00       	call   8c <cat>
    close(fd);
  42:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 b9 02 00 00       	call   307 <close>
  for(i = 1; i < argc; i++){
  4e:	46                   	inc    %esi
  4f:	83 c3 04             	add    $0x4,%ebx
  52:	39 fe                	cmp    %edi,%esi
  54:	75 ca                	jne    20 <main+0x20>
  }
  exit();
  56:	e8 84 02 00 00       	call   2df <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5b:	8b 03                	mov    (%ebx),%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 6d 07 00 	movl   $0x76d,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 b3 03 00 00       	call   428 <printf>
      exit();
  75:	e8 65 02 00 00       	call   2df <exit>
    cat(0);
  7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  81:	e8 06 00 00 00       	call   8c <cat>
    exit();
  86:	e8 54 02 00 00       	call   2df <exit>
  8b:	90                   	nop

0000008c <cat>:
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	56                   	push   %esi
  90:	53                   	push   %ebx
  91:	83 ec 10             	sub    $0x10,%esp
  94:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  97:	eb 1f                	jmp    b8 <cat+0x2c>
  99:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  a0:	c7 44 24 04 80 0a 00 	movl   $0xa80,0x4(%esp)
  a7:	00 
  a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  af:	e8 4b 02 00 00       	call   2ff <write>
  b4:	39 d8                	cmp    %ebx,%eax
  b6:	75 28                	jne    e0 <cat+0x54>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  b8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  bf:	00 
  c0:	c7 44 24 04 80 0a 00 	movl   $0xa80,0x4(%esp)
  c7:	00 
  c8:	89 34 24             	mov    %esi,(%esp)
  cb:	e8 27 02 00 00       	call   2f7 <read>
  d0:	89 c3                	mov    %eax,%ebx
  d2:	83 f8 00             	cmp    $0x0,%eax
  d5:	7f c5                	jg     9c <cat+0x10>
  if(n < 0){
  d7:	75 20                	jne    f9 <cat+0x6d>
}
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	5b                   	pop    %ebx
  dd:	5e                   	pop    %esi
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    
      printf(1, "cat: write error\n");
  e0:	c7 44 24 04 4a 07 00 	movl   $0x74a,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	e8 34 03 00 00       	call   428 <printf>
      exit();
  f4:	e8 e6 01 00 00       	call   2df <exit>
    printf(1, "cat: read error\n");
  f9:	c7 44 24 04 5c 07 00 	movl   $0x75c,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 1b 03 00 00       	call   428 <printf>
    exit();
 10d:	e8 cd 01 00 00       	call   2df <exit>
 112:	66 90                	xchg   %ax,%ax

00000114 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	53                   	push   %ebx
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11e:	89 c2                	mov    %eax,%edx
 120:	8a 19                	mov    (%ecx),%bl
 122:	88 1a                	mov    %bl,(%edx)
 124:	42                   	inc    %edx
 125:	41                   	inc    %ecx
 126:	84 db                	test   %bl,%bl
 128:	75 f6                	jne    120 <strcpy+0xc>
    ;
  return os;
}
 12a:	5b                   	pop    %ebx
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
 135:	8b 55 08             	mov    0x8(%ebp),%edx
 138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 13b:	0f b6 02             	movzbl (%edx),%eax
 13e:	0f b6 19             	movzbl (%ecx),%ebx
 141:	84 c0                	test   %al,%al
 143:	75 14                	jne    159 <strcmp+0x29>
 145:	eb 1d                	jmp    164 <strcmp+0x34>
 147:	90                   	nop
    p++, q++;
 148:	42                   	inc    %edx
 149:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 14c:	0f b6 02             	movzbl (%edx),%eax
 14f:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 153:	84 c0                	test   %al,%al
 155:	74 0d                	je     164 <strcmp+0x34>
    p++, q++;
 157:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 159:	38 d8                	cmp    %bl,%al
 15b:	74 eb                	je     148 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 15d:	29 d8                	sub    %ebx,%eax
}
 15f:	5b                   	pop    %ebx
 160:	5e                   	pop    %esi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop
  while(*p && *p == *q)
 164:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 166:	29 d8                	sub    %ebx,%eax
}
 168:	5b                   	pop    %ebx
 169:	5e                   	pop    %esi
 16a:	5d                   	pop    %ebp
 16b:	c3                   	ret    

0000016c <strlen>:

uint
strlen(char *s)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 172:	80 39 00             	cmpb   $0x0,(%ecx)
 175:	74 10                	je     187 <strlen+0x1b>
 177:	31 d2                	xor    %edx,%edx
 179:	8d 76 00             	lea    0x0(%esi),%esi
 17c:	42                   	inc    %edx
 17d:	89 d0                	mov    %edx,%eax
 17f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 183:	75 f7                	jne    17c <strlen+0x10>
    ;
  return n;
}
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
  for(n = 0; s[n]; n++)
 187:	31 c0                	xor    %eax,%eax
}
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop

0000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
 190:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 193:	89 d7                	mov    %edx,%edi
 195:	8b 4d 10             	mov    0x10(%ebp),%ecx
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	fc                   	cld    
 19c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19e:	89 d0                	mov    %edx,%eax
 1a0:	5f                   	pop    %edi
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	90                   	nop

000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ad:	8a 10                	mov    (%eax),%dl
 1af:	84 d2                	test   %dl,%dl
 1b1:	75 0c                	jne    1bf <strchr+0x1b>
 1b3:	eb 13                	jmp    1c8 <strchr+0x24>
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
 1b8:	40                   	inc    %eax
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 09                	je     1c8 <strchr+0x24>
    if(*s == c)
 1bf:	38 ca                	cmp    %cl,%dl
 1c1:	75 f5                	jne    1b8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1c8:	31 c0                	xor    %eax,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1d7:	8d 7d e7             	lea    -0x19(%ebp),%edi
 1da:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 1dc:	8d 73 01             	lea    0x1(%ebx),%esi
 1df:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1e2:	7d 40                	jge    224 <gets+0x58>
    cc = read(0, &c, 1);
 1e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1eb:	00 
 1ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f7:	e8 fb 00 00 00       	call   2f7 <read>
    if(cc < 1)
 1fc:	85 c0                	test   %eax,%eax
 1fe:	7e 24                	jle    224 <gets+0x58>
      break;
    buf[i++] = c;
 200:	8a 45 e7             	mov    -0x19(%ebp),%al
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 20a:	3c 0a                	cmp    $0xa,%al
 20c:	74 06                	je     214 <gets+0x48>
 20e:	89 f3                	mov    %esi,%ebx
 210:	3c 0d                	cmp    $0xd,%al
 212:	75 c8                	jne    1dc <gets+0x10>
      break;
  }
  buf[i] = '\0';
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 21b:	83 c4 2c             	add    $0x2c,%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	90                   	nop
    if(cc < 1)
 224:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 22d:	83 c4 2c             	add    $0x2c,%esp
 230:	5b                   	pop    %ebx
 231:	5e                   	pop    %esi
 232:	5f                   	pop    %edi
 233:	5d                   	pop    %ebp
 234:	c3                   	ret    
 235:	8d 76 00             	lea    0x0(%esi),%esi

00000238 <stat>:

int
stat(char *n, struct stat *st)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	56                   	push   %esi
 23c:	53                   	push   %ebx
 23d:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 247:	00 
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	89 04 24             	mov    %eax,(%esp)
 24e:	e8 cc 00 00 00       	call   31f <open>
 253:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 255:	85 c0                	test   %eax,%eax
 257:	78 23                	js     27c <stat+0x44>
    return -1;
  r = fstat(fd, st);
 259:	8b 45 0c             	mov    0xc(%ebp),%eax
 25c:	89 44 24 04          	mov    %eax,0x4(%esp)
 260:	89 1c 24             	mov    %ebx,(%esp)
 263:	e8 cf 00 00 00       	call   337 <fstat>
 268:	89 c6                	mov    %eax,%esi
  close(fd);
 26a:	89 1c 24             	mov    %ebx,(%esp)
 26d:	e8 95 00 00 00       	call   307 <close>
  return r;
}
 272:	89 f0                	mov    %esi,%eax
 274:	83 c4 10             	add    $0x10,%esp
 277:	5b                   	pop    %ebx
 278:	5e                   	pop    %esi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret    
 27b:	90                   	nop
    return -1;
 27c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 281:	eb ef                	jmp    272 <stat+0x3a>
 283:	90                   	nop

00000284 <atoi>:

int
atoi(const char *s)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	53                   	push   %ebx
 288:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28b:	0f be 11             	movsbl (%ecx),%edx
 28e:	8d 42 d0             	lea    -0x30(%edx),%eax
 291:	3c 09                	cmp    $0x9,%al
 293:	b8 00 00 00 00       	mov    $0x0,%eax
 298:	77 15                	ja     2af <atoi+0x2b>
 29a:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 29c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 29f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 2a3:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 2a4:	0f be 11             	movsbl (%ecx),%edx
 2a7:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2aa:	80 fb 09             	cmp    $0x9,%bl
 2ad:	76 ed                	jbe    29c <atoi+0x18>
  return n;
}
 2af:	5b                   	pop    %ebx
 2b0:	5d                   	pop    %ebp
 2b1:	c3                   	ret    
 2b2:	66 90                	xchg   %ax,%ax

000002b4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	56                   	push   %esi
 2b8:	53                   	push   %ebx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2bf:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 2c2:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c4:	85 f6                	test   %esi,%esi
 2c6:	7e 0b                	jle    2d3 <memmove+0x1f>
    *dst++ = *src++;
 2c8:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 2cb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ce:	42                   	inc    %edx
  while(n-- > 0)
 2cf:	39 f2                	cmp    %esi,%edx
 2d1:	75 f5                	jne    2c8 <memmove+0x14>
  return vdst;
}
 2d3:	5b                   	pop    %ebx
 2d4:	5e                   	pop    %esi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    

000002d7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d7:	b8 01 00 00 00       	mov    $0x1,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <exit>:
SYSCALL(exit)
 2df:	b8 02 00 00 00       	mov    $0x2,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <wait>:
SYSCALL(wait)
 2e7:	b8 03 00 00 00       	mov    $0x3,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <pipe>:
SYSCALL(pipe)
 2ef:	b8 04 00 00 00       	mov    $0x4,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <read>:
SYSCALL(read)
 2f7:	b8 05 00 00 00       	mov    $0x5,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <write>:
SYSCALL(write)
 2ff:	b8 10 00 00 00       	mov    $0x10,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <close>:
SYSCALL(close)
 307:	b8 15 00 00 00       	mov    $0x15,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <kill>:
SYSCALL(kill)
 30f:	b8 06 00 00 00       	mov    $0x6,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <exec>:
SYSCALL(exec)
 317:	b8 07 00 00 00       	mov    $0x7,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <open>:
SYSCALL(open)
 31f:	b8 0f 00 00 00       	mov    $0xf,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <mknod>:
SYSCALL(mknod)
 327:	b8 11 00 00 00       	mov    $0x11,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <unlink>:
SYSCALL(unlink)
 32f:	b8 12 00 00 00       	mov    $0x12,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <fstat>:
SYSCALL(fstat)
 337:	b8 08 00 00 00       	mov    $0x8,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <link>:
SYSCALL(link)
 33f:	b8 13 00 00 00       	mov    $0x13,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <mkdir>:
SYSCALL(mkdir)
 347:	b8 14 00 00 00       	mov    $0x14,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <chdir>:
SYSCALL(chdir)
 34f:	b8 09 00 00 00       	mov    $0x9,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <dup>:
SYSCALL(dup)
 357:	b8 0a 00 00 00       	mov    $0xa,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <getpid>:
SYSCALL(getpid)
 35f:	b8 0b 00 00 00       	mov    $0xb,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <getppid>:
SYSCALL(getppid)
 367:	b8 17 00 00 00       	mov    $0x17,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <sbrk>:
SYSCALL(sbrk)
 36f:	b8 0c 00 00 00       	mov    $0xc,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <sleep>:
SYSCALL(sleep)
 377:	b8 0d 00 00 00       	mov    $0xd,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <uptime>:
SYSCALL(uptime)
 37f:	b8 0e 00 00 00       	mov    $0xe,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <myfunction>:
SYSCALL(myfunction)
 387:	b8 16 00 00 00       	mov    $0x16,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <yield>:
SYSCALL(yield)
 38f:	b8 18 00 00 00       	mov    $0x18,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <getlev>:
SYSCALL(getlev)
 397:	b8 19 00 00 00       	mov    $0x19,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <set_cpu_share>:
 39f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    
 3a7:	90                   	nop

000003a8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	57                   	push   %edi
 3ac:	56                   	push   %esi
 3ad:	53                   	push   %ebx
 3ae:	83 ec 3c             	sub    $0x3c,%esp
 3b1:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b3:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3b8:	85 db                	test   %ebx,%ebx
 3ba:	74 04                	je     3c0 <printint+0x18>
 3bc:	85 d2                	test   %edx,%edx
 3be:	78 5d                	js     41d <printint+0x75>
  neg = 0;
 3c0:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 3c2:	31 f6                	xor    %esi,%esi
 3c4:	eb 04                	jmp    3ca <printint+0x22>
 3c6:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 3c8:	89 d6                	mov    %edx,%esi
 3ca:	31 d2                	xor    %edx,%edx
 3cc:	f7 f1                	div    %ecx
 3ce:	8a 92 89 07 00 00    	mov    0x789(%edx),%dl
 3d4:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 3d8:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 3db:	85 c0                	test   %eax,%eax
 3dd:	75 e9                	jne    3c8 <printint+0x20>
  if(neg)
 3df:	85 db                	test   %ebx,%ebx
 3e1:	74 08                	je     3eb <printint+0x43>
    buf[i++] = '-';
 3e3:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 3e8:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 3eb:	8d 5a ff             	lea    -0x1(%edx),%ebx
 3ee:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3f1:	8d 76 00             	lea    0x0(%esi),%esi
 3f4:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 3f8:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 402:	00 
 403:	89 74 24 04          	mov    %esi,0x4(%esp)
 407:	89 3c 24             	mov    %edi,(%esp)
 40a:	e8 f0 fe ff ff       	call   2ff <write>
  while(--i >= 0)
 40f:	4b                   	dec    %ebx
 410:	83 fb ff             	cmp    $0xffffffff,%ebx
 413:	75 df                	jne    3f4 <printint+0x4c>
    putc(fd, buf[i]);
}
 415:	83 c4 3c             	add    $0x3c,%esp
 418:	5b                   	pop    %ebx
 419:	5e                   	pop    %esi
 41a:	5f                   	pop    %edi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
    x = -xx;
 41d:	f7 d8                	neg    %eax
    neg = 1;
 41f:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 424:	eb 9c                	jmp    3c2 <printint+0x1a>
 426:	66 90                	xchg   %ax,%ax

00000428 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	57                   	push   %edi
 42c:	56                   	push   %esi
 42d:	53                   	push   %ebx
 42e:	83 ec 3c             	sub    $0x3c,%esp
 431:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 437:	8a 03                	mov    (%ebx),%al
 439:	84 c0                	test   %al,%al
 43b:	0f 84 bb 00 00 00    	je     4fc <printf+0xd4>
printf(int fd, char *fmt, ...)
 441:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 442:	8d 55 10             	lea    0x10(%ebp),%edx
 445:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 448:	31 ff                	xor    %edi,%edi
 44a:	eb 2f                	jmp    47b <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 44c:	83 f9 25             	cmp    $0x25,%ecx
 44f:	0f 84 af 00 00 00    	je     504 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 455:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45f:	00 
 460:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 463:	89 44 24 04          	mov    %eax,0x4(%esp)
 467:	89 34 24             	mov    %esi,(%esp)
 46a:	e8 90 fe ff ff       	call   2ff <write>
 46f:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 470:	8a 43 ff             	mov    -0x1(%ebx),%al
 473:	84 c0                	test   %al,%al
 475:	0f 84 81 00 00 00    	je     4fc <printf+0xd4>
    c = fmt[i] & 0xff;
 47b:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 47e:	85 ff                	test   %edi,%edi
 480:	74 ca                	je     44c <printf+0x24>
      }
    } else if(state == '%'){
 482:	83 ff 25             	cmp    $0x25,%edi
 485:	75 e8                	jne    46f <printf+0x47>
      if(c == 'd'){
 487:	83 f9 64             	cmp    $0x64,%ecx
 48a:	0f 84 14 01 00 00    	je     5a4 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 490:	83 f9 78             	cmp    $0x78,%ecx
 493:	74 7b                	je     510 <printf+0xe8>
 495:	83 f9 70             	cmp    $0x70,%ecx
 498:	74 76                	je     510 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49a:	83 f9 73             	cmp    $0x73,%ecx
 49d:	0f 84 91 00 00 00    	je     534 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a3:	83 f9 63             	cmp    $0x63,%ecx
 4a6:	0f 84 cc 00 00 00    	je     578 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ac:	83 f9 25             	cmp    $0x25,%ecx
 4af:	0f 84 13 01 00 00    	je     5c8 <printf+0x1a0>
 4b5:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 4b9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c0:	00 
 4c1:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c8:	89 34 24             	mov    %esi,(%esp)
 4cb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 4ce:	e8 2c fe ff ff       	call   2ff <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4d3:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 4d6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 4d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e0:	00 
 4e1:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4e4:	89 54 24 04          	mov    %edx,0x4(%esp)
 4e8:	89 34 24             	mov    %esi,(%esp)
 4eb:	e8 0f fe ff ff       	call   2ff <write>
      }
      state = 0;
 4f0:	31 ff                	xor    %edi,%edi
 4f2:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 4f3:	8a 43 ff             	mov    -0x1(%ebx),%al
 4f6:	84 c0                	test   %al,%al
 4f8:	75 81                	jne    47b <printf+0x53>
 4fa:	66 90                	xchg   %ax,%ax
    }
  }
}
 4fc:	83 c4 3c             	add    $0x3c,%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
        state = '%';
 504:	bf 25 00 00 00       	mov    $0x25,%edi
 509:	e9 61 ff ff ff       	jmp    46f <printf+0x47>
 50e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 517:	b9 10 00 00 00       	mov    $0x10,%ecx
 51c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 51f:	8b 10                	mov    (%eax),%edx
 521:	89 f0                	mov    %esi,%eax
 523:	e8 80 fe ff ff       	call   3a8 <printint>
        ap++;
 528:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 52c:	31 ff                	xor    %edi,%edi
        ap++;
 52e:	e9 3c ff ff ff       	jmp    46f <printf+0x47>
 533:	90                   	nop
        s = (char*)*ap;
 534:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 537:	8b 3a                	mov    (%edx),%edi
        ap++;
 539:	83 c2 04             	add    $0x4,%edx
 53c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 53f:	85 ff                	test   %edi,%edi
 541:	0f 84 a3 00 00 00    	je     5ea <printf+0x1c2>
        while(*s != 0){
 547:	8a 07                	mov    (%edi),%al
 549:	84 c0                	test   %al,%al
 54b:	74 24                	je     571 <printf+0x149>
 54d:	8d 76 00             	lea    0x0(%esi),%esi
 550:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 553:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 55a:	00 
 55b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 55e:	89 44 24 04          	mov    %eax,0x4(%esp)
 562:	89 34 24             	mov    %esi,(%esp)
 565:	e8 95 fd ff ff       	call   2ff <write>
          s++;
 56a:	47                   	inc    %edi
        while(*s != 0){
 56b:	8a 07                	mov    (%edi),%al
 56d:	84 c0                	test   %al,%al
 56f:	75 df                	jne    550 <printf+0x128>
      state = 0;
 571:	31 ff                	xor    %edi,%edi
 573:	e9 f7 fe ff ff       	jmp    46f <printf+0x47>
        putc(fd, *ap);
 578:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 57b:	8b 02                	mov    (%edx),%eax
 57d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 580:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 587:	00 
 588:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	89 34 24             	mov    %esi,(%esp)
 592:	e8 68 fd ff ff       	call   2ff <write>
        ap++;
 597:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 59b:	31 ff                	xor    %edi,%edi
 59d:	e9 cd fe ff ff       	jmp    46f <printf+0x47>
 5a2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ab:	b1 0a                	mov    $0xa,%cl
 5ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5b0:	8b 10                	mov    (%eax),%edx
 5b2:	89 f0                	mov    %esi,%eax
 5b4:	e8 ef fd ff ff       	call   3a8 <printint>
        ap++;
 5b9:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 5bd:	66 31 ff             	xor    %di,%di
 5c0:	e9 aa fe ff ff       	jmp    46f <printf+0x47>
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
 5c8:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 5cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d3:	00 
 5d4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	89 34 24             	mov    %esi,(%esp)
 5de:	e8 1c fd ff ff       	call   2ff <write>
      state = 0;
 5e3:	31 ff                	xor    %edi,%edi
 5e5:	e9 85 fe ff ff       	jmp    46f <printf+0x47>
          s = "(null)";
 5ea:	bf 82 07 00 00       	mov    $0x782,%edi
 5ef:	e9 53 ff ff ff       	jmp    547 <printf+0x11f>

000005f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	56                   	push   %esi
 5f9:	53                   	push   %ebx
 5fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fd:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 600:	a1 60 0a 00 00       	mov    0xa60,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 605:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 607:	39 d0                	cmp    %edx,%eax
 609:	72 11                	jb     61c <free+0x28>
 60b:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	72 04                	jb     614 <free+0x20>
 610:	39 ca                	cmp    %ecx,%edx
 612:	72 10                	jb     624 <free+0x30>
 614:	89 c8                	mov    %ecx,%eax
 616:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 618:	39 d0                	cmp    %edx,%eax
 61a:	73 f0                	jae    60c <free+0x18>
 61c:	39 ca                	cmp    %ecx,%edx
 61e:	72 04                	jb     624 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 c8                	cmp    %ecx,%eax
 622:	72 f0                	jb     614 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 624:	8b 73 fc             	mov    -0x4(%ebx),%esi
 627:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 62a:	39 cf                	cmp    %ecx,%edi
 62c:	74 1a                	je     648 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 62e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 631:	8b 48 04             	mov    0x4(%eax),%ecx
 634:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 637:	39 f2                	cmp    %esi,%edx
 639:	74 24                	je     65f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63b:	89 10                	mov    %edx,(%eax)
  freep = p;
 63d:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 642:	5b                   	pop    %ebx
 643:	5e                   	pop    %esi
 644:	5f                   	pop    %edi
 645:	5d                   	pop    %ebp
 646:	c3                   	ret    
 647:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 648:	03 71 04             	add    0x4(%ecx),%esi
 64b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 64e:	8b 08                	mov    (%eax),%ecx
 650:	8b 09                	mov    (%ecx),%ecx
 652:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 655:	8b 48 04             	mov    0x4(%eax),%ecx
 658:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 65b:	39 f2                	cmp    %esi,%edx
 65d:	75 dc                	jne    63b <free+0x47>
    p->s.size += bp->s.size;
 65f:	03 4b fc             	add    -0x4(%ebx),%ecx
 662:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 665:	8b 53 f8             	mov    -0x8(%ebx),%edx
 668:	89 10                	mov    %edx,(%eax)
  freep = p;
 66a:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    

00000674 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	57                   	push   %edi
 678:	56                   	push   %esi
 679:	53                   	push   %ebx
 67a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67d:	8b 75 08             	mov    0x8(%ebp),%esi
 680:	83 c6 07             	add    $0x7,%esi
 683:	c1 ee 03             	shr    $0x3,%esi
 686:	46                   	inc    %esi
  if((prevp = freep) == 0){
 687:	8b 15 60 0a 00 00    	mov    0xa60,%edx
 68d:	85 d2                	test   %edx,%edx
 68f:	0f 84 8d 00 00 00    	je     722 <malloc+0xae>
 695:	8b 02                	mov    (%edx),%eax
 697:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 69a:	39 ce                	cmp    %ecx,%esi
 69c:	76 52                	jbe    6f0 <malloc+0x7c>
 69e:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 6a5:	eb 0a                	jmp    6b1 <malloc+0x3d>
 6a7:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6aa:	8b 48 04             	mov    0x4(%eax),%ecx
 6ad:	39 ce                	cmp    %ecx,%esi
 6af:	76 3f                	jbe    6f0 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b1:	89 c2                	mov    %eax,%edx
 6b3:	3b 05 60 0a 00 00    	cmp    0xa60,%eax
 6b9:	75 ed                	jne    6a8 <malloc+0x34>
  if(nu < 4096)
 6bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 6c1:	76 4d                	jbe    710 <malloc+0x9c>
 6c3:	89 d8                	mov    %ebx,%eax
 6c5:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 6c7:	89 04 24             	mov    %eax,(%esp)
 6ca:	e8 a0 fc ff ff       	call   36f <sbrk>
  if(p == (char*)-1)
 6cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d2:	74 18                	je     6ec <malloc+0x78>
  hp->s.size = nu;
 6d4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6d7:	83 c0 08             	add    $0x8,%eax
 6da:	89 04 24             	mov    %eax,(%esp)
 6dd:	e8 12 ff ff ff       	call   5f4 <free>
  return freep;
 6e2:	8b 15 60 0a 00 00    	mov    0xa60,%edx
      if((p = morecore(nunits)) == 0)
 6e8:	85 d2                	test   %edx,%edx
 6ea:	75 bc                	jne    6a8 <malloc+0x34>
        return 0;
 6ec:	31 c0                	xor    %eax,%eax
 6ee:	eb 18                	jmp    708 <malloc+0x94>
      if(p->s.size == nunits)
 6f0:	39 ce                	cmp    %ecx,%esi
 6f2:	74 28                	je     71c <malloc+0xa8>
        p->s.size -= nunits;
 6f4:	29 f1                	sub    %esi,%ecx
 6f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6fc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6ff:	89 15 60 0a 00 00    	mov    %edx,0xa60
      return (void*)(p + 1);
 705:	83 c0 08             	add    $0x8,%eax
  }
}
 708:	83 c4 1c             	add    $0x1c,%esp
 70b:	5b                   	pop    %ebx
 70c:	5e                   	pop    %esi
 70d:	5f                   	pop    %edi
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret    
  if(nu < 4096)
 710:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 715:	bf 00 10 00 00       	mov    $0x1000,%edi
 71a:	eb ab                	jmp    6c7 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 71c:	8b 08                	mov    (%eax),%ecx
 71e:	89 0a                	mov    %ecx,(%edx)
 720:	eb dd                	jmp    6ff <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 722:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 729:	0a 00 00 
 72c:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 733:	0a 00 00 
    base.s.size = 0;
 736:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 73d:	00 00 00 
 740:	b8 64 0a 00 00       	mov    $0xa64,%eax
 745:	e9 54 ff ff ff       	jmp    69e <malloc+0x2a>
