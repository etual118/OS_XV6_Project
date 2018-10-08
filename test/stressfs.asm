
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   f:	8d 44 24 26          	lea    0x26(%esp),%eax
  13:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  17:	be 81 07 00 00       	mov    $0x781,%esi
  1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  21:	89 c7                	mov    %eax,%edi
  23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  25:	c7 44 24 04 5e 07 00 	movl   $0x75e,0x4(%esp)
  2c:	00 
  2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  34:	e8 03 04 00 00       	call   43c <printf>
  memset(data, 'a', sizeof(data));
  39:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  40:	00 
  41:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  48:	00 
  49:	8d 74 24 30          	lea    0x30(%esp),%esi
  4d:	89 34 24             	mov    %esi,(%esp)
  50:	e8 4b 01 00 00       	call   1a0 <memset>

  for(i = 0; i < 4; i++)
  55:	31 db                	xor    %ebx,%ebx
    if(fork() > 0)
  57:	e8 8f 02 00 00       	call   2eb <fork>
  5c:	85 c0                	test   %eax,%eax
  5e:	0f 8f bd 00 00 00    	jg     121 <main+0x121>
  for(i = 0; i < 4; i++)
  64:	43                   	inc    %ebx
  65:	83 fb 04             	cmp    $0x4,%ebx
  68:	75 ed                	jne    57 <main+0x57>
  6a:	bf 04 00 00 00       	mov    $0x4,%edi
      break;

  printf(1, "write %d\n", i);
  6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  73:	c7 44 24 04 71 07 00 	movl   $0x771,0x4(%esp)
  7a:	00 
  7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  82:	e8 b5 03 00 00       	call   43c <printf>

  path[8] += i;
  87:	89 f8                	mov    %edi,%eax
  89:	00 44 24 2e          	add    %al,0x2e(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  8d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  94:	00 
  95:	8d 44 24 26          	lea    0x26(%esp),%eax
  99:	89 04 24             	mov    %eax,(%esp)
  9c:	e8 92 02 00 00       	call   333 <open>
  a1:	89 c7                	mov    %eax,%edi
  a3:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  a8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  af:	00 
  b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  b4:	89 3c 24             	mov    %edi,(%esp)
  b7:	e8 57 02 00 00       	call   313 <write>
  for(i = 0; i < 20; i++)
  bc:	4b                   	dec    %ebx
  bd:	75 e9                	jne    a8 <main+0xa8>
  close(fd);
  bf:	89 3c 24             	mov    %edi,(%esp)
  c2:	e8 54 02 00 00       	call   31b <close>

  printf(1, "read\n");
  c7:	c7 44 24 04 7b 07 00 	movl   $0x77b,0x4(%esp)
  ce:	00 
  cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d6:	e8 61 03 00 00       	call   43c <printf>

  fd = open(path, O_RDONLY);
  db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  e2:	00 
  e3:	8d 44 24 26          	lea    0x26(%esp),%eax
  e7:	89 04 24             	mov    %eax,(%esp)
  ea:	e8 44 02 00 00       	call   333 <open>
  ef:	89 c7                	mov    %eax,%edi
  f1:	bb 14 00 00 00       	mov    $0x14,%ebx
  f6:	66 90                	xchg   %ax,%ax
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  f8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  ff:	00 
 100:	89 74 24 04          	mov    %esi,0x4(%esp)
 104:	89 3c 24             	mov    %edi,(%esp)
 107:	e8 ff 01 00 00       	call   30b <read>
  for (i = 0; i < 20; i++)
 10c:	4b                   	dec    %ebx
 10d:	75 e9                	jne    f8 <main+0xf8>
  close(fd);
 10f:	89 3c 24             	mov    %edi,(%esp)
 112:	e8 04 02 00 00       	call   31b <close>

  wait();
 117:	e8 df 01 00 00       	call   2fb <wait>

  exit();
 11c:	e8 d2 01 00 00       	call   2f3 <exit>
 121:	89 df                	mov    %ebx,%edi
 123:	e9 47 ff ff ff       	jmp    6f <main+0x6f>

00000128 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	53                   	push   %ebx
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 132:	89 c2                	mov    %eax,%edx
 134:	8a 19                	mov    (%ecx),%bl
 136:	88 1a                	mov    %bl,(%edx)
 138:	42                   	inc    %edx
 139:	41                   	inc    %ecx
 13a:	84 db                	test   %bl,%bl
 13c:	75 f6                	jne    134 <strcpy+0xc>
    ;
  return os;
}
 13e:	5b                   	pop    %ebx
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	8d 76 00             	lea    0x0(%esi),%esi

00000144 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	56                   	push   %esi
 148:	53                   	push   %ebx
 149:	8b 55 08             	mov    0x8(%ebp),%edx
 14c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 14f:	0f b6 02             	movzbl (%edx),%eax
 152:	0f b6 19             	movzbl (%ecx),%ebx
 155:	84 c0                	test   %al,%al
 157:	75 14                	jne    16d <strcmp+0x29>
 159:	eb 1d                	jmp    178 <strcmp+0x34>
 15b:	90                   	nop
    p++, q++;
 15c:	42                   	inc    %edx
 15d:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 160:	0f b6 02             	movzbl (%edx),%eax
 163:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 167:	84 c0                	test   %al,%al
 169:	74 0d                	je     178 <strcmp+0x34>
    p++, q++;
 16b:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 16d:	38 d8                	cmp    %bl,%al
 16f:	74 eb                	je     15c <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 171:	29 d8                	sub    %ebx,%eax
}
 173:	5b                   	pop    %ebx
 174:	5e                   	pop    %esi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	90                   	nop
  while(*p && *p == *q)
 178:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 17a:	29 d8                	sub    %ebx,%eax
}
 17c:	5b                   	pop    %ebx
 17d:	5e                   	pop    %esi
 17e:	5d                   	pop    %ebp
 17f:	c3                   	ret    

00000180 <strlen>:

uint
strlen(char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 186:	80 39 00             	cmpb   $0x0,(%ecx)
 189:	74 10                	je     19b <strlen+0x1b>
 18b:	31 d2                	xor    %edx,%edx
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	42                   	inc    %edx
 191:	89 d0                	mov    %edx,%eax
 193:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 197:	75 f7                	jne    190 <strlen+0x10>
    ;
  return n;
}
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
  for(n = 0; s[n]; n++)
 19b:	31 c0                	xor    %eax,%eax
}
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    
 19f:	90                   	nop

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	89 d7                	mov    %edx,%edi
 1a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	90                   	nop

000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
 1be:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1c1:	8a 10                	mov    (%eax),%dl
 1c3:	84 d2                	test   %dl,%dl
 1c5:	75 0c                	jne    1d3 <strchr+0x1b>
 1c7:	eb 13                	jmp    1dc <strchr+0x24>
 1c9:	8d 76 00             	lea    0x0(%esi),%esi
 1cc:	40                   	inc    %eax
 1cd:	8a 10                	mov    (%eax),%dl
 1cf:	84 d2                	test   %dl,%dl
 1d1:	74 09                	je     1dc <strchr+0x24>
    if(*s == c)
 1d3:	38 ca                	cmp    %cl,%dl
 1d5:	75 f5                	jne    1cc <strchr+0x14>
      return (char*)s;
  return 0;
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1dc:	31 c0                	xor    %eax,%eax
}
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    

000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
 1e6:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 1ee:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 1f0:	8d 73 01             	lea    0x1(%ebx),%esi
 1f3:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1f6:	7d 40                	jge    238 <gets+0x58>
    cc = read(0, &c, 1);
 1f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ff:	00 
 200:	89 7c 24 04          	mov    %edi,0x4(%esp)
 204:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 20b:	e8 fb 00 00 00       	call   30b <read>
    if(cc < 1)
 210:	85 c0                	test   %eax,%eax
 212:	7e 24                	jle    238 <gets+0x58>
      break;
    buf[i++] = c;
 214:	8a 45 e7             	mov    -0x19(%ebp),%al
 217:	8b 55 08             	mov    0x8(%ebp),%edx
 21a:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 21e:	3c 0a                	cmp    $0xa,%al
 220:	74 06                	je     228 <gets+0x48>
 222:	89 f3                	mov    %esi,%ebx
 224:	3c 0d                	cmp    $0xd,%al
 226:	75 c8                	jne    1f0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 22f:	83 c4 2c             	add    $0x2c,%esp
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5f                   	pop    %edi
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    
 237:	90                   	nop
    if(cc < 1)
 238:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 241:	83 c4 2c             	add    $0x2c,%esp
 244:	5b                   	pop    %ebx
 245:	5e                   	pop    %esi
 246:	5f                   	pop    %edi
 247:	5d                   	pop    %ebp
 248:	c3                   	ret    
 249:	8d 76 00             	lea    0x0(%esi),%esi

0000024c <stat>:

int
stat(char *n, struct stat *st)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	56                   	push   %esi
 250:	53                   	push   %ebx
 251:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25b:	00 
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	89 04 24             	mov    %eax,(%esp)
 262:	e8 cc 00 00 00       	call   333 <open>
 267:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 269:	85 c0                	test   %eax,%eax
 26b:	78 23                	js     290 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	89 1c 24             	mov    %ebx,(%esp)
 277:	e8 cf 00 00 00       	call   34b <fstat>
 27c:	89 c6                	mov    %eax,%esi
  close(fd);
 27e:	89 1c 24             	mov    %ebx,(%esp)
 281:	e8 95 00 00 00       	call   31b <close>
  return r;
}
 286:	89 f0                	mov    %esi,%eax
 288:	83 c4 10             	add    $0x10,%esp
 28b:	5b                   	pop    %ebx
 28c:	5e                   	pop    %esi
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop
    return -1;
 290:	be ff ff ff ff       	mov    $0xffffffff,%esi
 295:	eb ef                	jmp    286 <stat+0x3a>
 297:	90                   	nop

00000298 <atoi>:

int
atoi(const char *s)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	53                   	push   %ebx
 29c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29f:	0f be 11             	movsbl (%ecx),%edx
 2a2:	8d 42 d0             	lea    -0x30(%edx),%eax
 2a5:	3c 09                	cmp    $0x9,%al
 2a7:	b8 00 00 00 00       	mov    $0x0,%eax
 2ac:	77 15                	ja     2c3 <atoi+0x2b>
 2ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2b3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 2b7:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 2b8:	0f be 11             	movsbl (%ecx),%edx
 2bb:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2be:	80 fb 09             	cmp    $0x9,%bl
 2c1:	76 ed                	jbe    2b0 <atoi+0x18>
  return n;
}
 2c3:	5b                   	pop    %ebx
 2c4:	5d                   	pop    %ebp
 2c5:	c3                   	ret    
 2c6:	66 90                	xchg   %ax,%ax

000002c8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	56                   	push   %esi
 2cc:	53                   	push   %ebx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2d3:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 2d6:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d8:	85 f6                	test   %esi,%esi
 2da:	7e 0b                	jle    2e7 <memmove+0x1f>
    *dst++ = *src++;
 2dc:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 2df:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2e2:	42                   	inc    %edx
  while(n-- > 0)
 2e3:	39 f2                	cmp    %esi,%edx
 2e5:	75 f5                	jne    2dc <memmove+0x14>
  return vdst;
}
 2e7:	5b                   	pop    %ebx
 2e8:	5e                   	pop    %esi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getppid>:
SYSCALL(getppid)
 37b:	b8 17 00 00 00       	mov    $0x17,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sbrk>:
SYSCALL(sbrk)
 383:	b8 0c 00 00 00       	mov    $0xc,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sleep>:
SYSCALL(sleep)
 38b:	b8 0d 00 00 00       	mov    $0xd,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <uptime>:
SYSCALL(uptime)
 393:	b8 0e 00 00 00       	mov    $0xe,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <myfunction>:
SYSCALL(myfunction)
 39b:	b8 16 00 00 00       	mov    $0x16,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <yield>:
SYSCALL(yield)
 3a3:	b8 18 00 00 00       	mov    $0x18,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <getlev>:
SYSCALL(getlev)
 3ab:	b8 19 00 00 00       	mov    $0x19,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <set_cpu_share>:
 3b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    
 3bb:	90                   	nop

000003bc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	57                   	push   %edi
 3c0:	56                   	push   %esi
 3c1:	53                   	push   %ebx
 3c2:	83 ec 3c             	sub    $0x3c,%esp
 3c5:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3c7:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3cc:	85 db                	test   %ebx,%ebx
 3ce:	74 04                	je     3d4 <printint+0x18>
 3d0:	85 d2                	test   %edx,%edx
 3d2:	78 5d                	js     431 <printint+0x75>
  neg = 0;
 3d4:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 3d6:	31 f6                	xor    %esi,%esi
 3d8:	eb 04                	jmp    3de <printint+0x22>
 3da:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 3dc:	89 d6                	mov    %edx,%esi
 3de:	31 d2                	xor    %edx,%edx
 3e0:	f7 f1                	div    %ecx
 3e2:	8a 92 92 07 00 00    	mov    0x792(%edx),%dl
 3e8:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 3ec:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 3ef:	85 c0                	test   %eax,%eax
 3f1:	75 e9                	jne    3dc <printint+0x20>
  if(neg)
 3f3:	85 db                	test   %ebx,%ebx
 3f5:	74 08                	je     3ff <printint+0x43>
    buf[i++] = '-';
 3f7:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 3fc:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 3ff:	8d 5a ff             	lea    -0x1(%edx),%ebx
 402:	8d 75 d7             	lea    -0x29(%ebp),%esi
 405:	8d 76 00             	lea    0x0(%esi),%esi
 408:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 40c:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 40f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 416:	00 
 417:	89 74 24 04          	mov    %esi,0x4(%esp)
 41b:	89 3c 24             	mov    %edi,(%esp)
 41e:	e8 f0 fe ff ff       	call   313 <write>
  while(--i >= 0)
 423:	4b                   	dec    %ebx
 424:	83 fb ff             	cmp    $0xffffffff,%ebx
 427:	75 df                	jne    408 <printint+0x4c>
    putc(fd, buf[i]);
}
 429:	83 c4 3c             	add    $0x3c,%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
    x = -xx;
 431:	f7 d8                	neg    %eax
    neg = 1;
 433:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 438:	eb 9c                	jmp    3d6 <printint+0x1a>
 43a:	66 90                	xchg   %ax,%ax

0000043c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	57                   	push   %edi
 440:	56                   	push   %esi
 441:	53                   	push   %ebx
 442:	83 ec 3c             	sub    $0x3c,%esp
 445:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 448:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 44b:	8a 03                	mov    (%ebx),%al
 44d:	84 c0                	test   %al,%al
 44f:	0f 84 bb 00 00 00    	je     510 <printf+0xd4>
printf(int fd, char *fmt, ...)
 455:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 456:	8d 55 10             	lea    0x10(%ebp),%edx
 459:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 45c:	31 ff                	xor    %edi,%edi
 45e:	eb 2f                	jmp    48f <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 460:	83 f9 25             	cmp    $0x25,%ecx
 463:	0f 84 af 00 00 00    	je     518 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 469:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 46c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 473:	00 
 474:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	89 34 24             	mov    %esi,(%esp)
 47e:	e8 90 fe ff ff       	call   313 <write>
 483:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 484:	8a 43 ff             	mov    -0x1(%ebx),%al
 487:	84 c0                	test   %al,%al
 489:	0f 84 81 00 00 00    	je     510 <printf+0xd4>
    c = fmt[i] & 0xff;
 48f:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 492:	85 ff                	test   %edi,%edi
 494:	74 ca                	je     460 <printf+0x24>
      }
    } else if(state == '%'){
 496:	83 ff 25             	cmp    $0x25,%edi
 499:	75 e8                	jne    483 <printf+0x47>
      if(c == 'd'){
 49b:	83 f9 64             	cmp    $0x64,%ecx
 49e:	0f 84 14 01 00 00    	je     5b8 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a4:	83 f9 78             	cmp    $0x78,%ecx
 4a7:	74 7b                	je     524 <printf+0xe8>
 4a9:	83 f9 70             	cmp    $0x70,%ecx
 4ac:	74 76                	je     524 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ae:	83 f9 73             	cmp    $0x73,%ecx
 4b1:	0f 84 91 00 00 00    	je     548 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b7:	83 f9 63             	cmp    $0x63,%ecx
 4ba:	0f 84 cc 00 00 00    	je     58c <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c0:	83 f9 25             	cmp    $0x25,%ecx
 4c3:	0f 84 13 01 00 00    	je     5dc <printf+0x1a0>
 4c9:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 4cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d4:	00 
 4d5:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	89 34 24             	mov    %esi,(%esp)
 4df:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 4e2:	e8 2c fe ff ff       	call   313 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4e7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 4ea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 4ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f4:	00 
 4f5:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4f8:	89 54 24 04          	mov    %edx,0x4(%esp)
 4fc:	89 34 24             	mov    %esi,(%esp)
 4ff:	e8 0f fe ff ff       	call   313 <write>
      }
      state = 0;
 504:	31 ff                	xor    %edi,%edi
 506:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 507:	8a 43 ff             	mov    -0x1(%ebx),%al
 50a:	84 c0                	test   %al,%al
 50c:	75 81                	jne    48f <printf+0x53>
 50e:	66 90                	xchg   %ax,%ax
    }
  }
}
 510:	83 c4 3c             	add    $0x3c,%esp
 513:	5b                   	pop    %ebx
 514:	5e                   	pop    %esi
 515:	5f                   	pop    %edi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    
        state = '%';
 518:	bf 25 00 00 00       	mov    $0x25,%edi
 51d:	e9 61 ff ff ff       	jmp    483 <printf+0x47>
 522:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 524:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 52b:	b9 10 00 00 00       	mov    $0x10,%ecx
 530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 533:	8b 10                	mov    (%eax),%edx
 535:	89 f0                	mov    %esi,%eax
 537:	e8 80 fe ff ff       	call   3bc <printint>
        ap++;
 53c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 540:	31 ff                	xor    %edi,%edi
        ap++;
 542:	e9 3c ff ff ff       	jmp    483 <printf+0x47>
 547:	90                   	nop
        s = (char*)*ap;
 548:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 54b:	8b 3a                	mov    (%edx),%edi
        ap++;
 54d:	83 c2 04             	add    $0x4,%edx
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 553:	85 ff                	test   %edi,%edi
 555:	0f 84 a3 00 00 00    	je     5fe <printf+0x1c2>
        while(*s != 0){
 55b:	8a 07                	mov    (%edi),%al
 55d:	84 c0                	test   %al,%al
 55f:	74 24                	je     585 <printf+0x149>
 561:	8d 76 00             	lea    0x0(%esi),%esi
 564:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 567:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 56e:	00 
 56f:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	89 34 24             	mov    %esi,(%esp)
 579:	e8 95 fd ff ff       	call   313 <write>
          s++;
 57e:	47                   	inc    %edi
        while(*s != 0){
 57f:	8a 07                	mov    (%edi),%al
 581:	84 c0                	test   %al,%al
 583:	75 df                	jne    564 <printf+0x128>
      state = 0;
 585:	31 ff                	xor    %edi,%edi
 587:	e9 f7 fe ff ff       	jmp    483 <printf+0x47>
        putc(fd, *ap);
 58c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 58f:	8b 02                	mov    (%edx),%eax
 591:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 594:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59b:	00 
 59c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	89 34 24             	mov    %esi,(%esp)
 5a6:	e8 68 fd ff ff       	call   313 <write>
        ap++;
 5ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 5af:	31 ff                	xor    %edi,%edi
 5b1:	e9 cd fe ff ff       	jmp    483 <printf+0x47>
 5b6:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5bf:	b1 0a                	mov    $0xa,%cl
 5c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	89 f0                	mov    %esi,%eax
 5c8:	e8 ef fd ff ff       	call   3bc <printint>
        ap++;
 5cd:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 5d1:	66 31 ff             	xor    %di,%di
 5d4:	e9 aa fe ff ff       	jmp    483 <printf+0x47>
 5d9:	8d 76 00             	lea    0x0(%esi),%esi
 5dc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 5e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e7:	00 
 5e8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	89 34 24             	mov    %esi,(%esp)
 5f2:	e8 1c fd ff ff       	call   313 <write>
      state = 0;
 5f7:	31 ff                	xor    %edi,%edi
 5f9:	e9 85 fe ff ff       	jmp    483 <printf+0x47>
          s = "(null)";
 5fe:	bf 8b 07 00 00       	mov    $0x78b,%edi
 603:	e9 53 ff ff ff       	jmp    55b <printf+0x11f>

00000608 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	57                   	push   %edi
 60c:	56                   	push   %esi
 60d:	53                   	push   %ebx
 60e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 611:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	a1 28 0a 00 00       	mov    0xa28,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 619:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61b:	39 d0                	cmp    %edx,%eax
 61d:	72 11                	jb     630 <free+0x28>
 61f:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 c8                	cmp    %ecx,%eax
 622:	72 04                	jb     628 <free+0x20>
 624:	39 ca                	cmp    %ecx,%edx
 626:	72 10                	jb     638 <free+0x30>
 628:	89 c8                	mov    %ecx,%eax
 62a:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	39 d0                	cmp    %edx,%eax
 62e:	73 f0                	jae    620 <free+0x18>
 630:	39 ca                	cmp    %ecx,%edx
 632:	72 04                	jb     638 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	39 c8                	cmp    %ecx,%eax
 636:	72 f0                	jb     628 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63b:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 63e:	39 cf                	cmp    %ecx,%edi
 640:	74 1a                	je     65c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 642:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 645:	8b 48 04             	mov    0x4(%eax),%ecx
 648:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 64b:	39 f2                	cmp    %esi,%edx
 64d:	74 24                	je     673 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64f:	89 10                	mov    %edx,(%eax)
  freep = p;
 651:	a3 28 0a 00 00       	mov    %eax,0xa28
}
 656:	5b                   	pop    %ebx
 657:	5e                   	pop    %esi
 658:	5f                   	pop    %edi
 659:	5d                   	pop    %ebp
 65a:	c3                   	ret    
 65b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 65c:	03 71 04             	add    0x4(%ecx),%esi
 65f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 662:	8b 08                	mov    (%eax),%ecx
 664:	8b 09                	mov    (%ecx),%ecx
 666:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 669:	8b 48 04             	mov    0x4(%eax),%ecx
 66c:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 66f:	39 f2                	cmp    %esi,%edx
 671:	75 dc                	jne    64f <free+0x47>
    p->s.size += bp->s.size;
 673:	03 4b fc             	add    -0x4(%ebx),%ecx
 676:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 679:	8b 53 f8             	mov    -0x8(%ebx),%edx
 67c:	89 10                	mov    %edx,(%eax)
  freep = p;
 67e:	a3 28 0a 00 00       	mov    %eax,0xa28
}
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    

00000688 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	57                   	push   %edi
 68c:	56                   	push   %esi
 68d:	53                   	push   %ebx
 68e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 691:	8b 75 08             	mov    0x8(%ebp),%esi
 694:	83 c6 07             	add    $0x7,%esi
 697:	c1 ee 03             	shr    $0x3,%esi
 69a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 69b:	8b 15 28 0a 00 00    	mov    0xa28,%edx
 6a1:	85 d2                	test   %edx,%edx
 6a3:	0f 84 8d 00 00 00    	je     736 <malloc+0xae>
 6a9:	8b 02                	mov    (%edx),%eax
 6ab:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6ae:	39 ce                	cmp    %ecx,%esi
 6b0:	76 52                	jbe    704 <malloc+0x7c>
 6b2:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 6b9:	eb 0a                	jmp    6c5 <malloc+0x3d>
 6bb:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6bc:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6be:	8b 48 04             	mov    0x4(%eax),%ecx
 6c1:	39 ce                	cmp    %ecx,%esi
 6c3:	76 3f                	jbe    704 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c5:	89 c2                	mov    %eax,%edx
 6c7:	3b 05 28 0a 00 00    	cmp    0xa28,%eax
 6cd:	75 ed                	jne    6bc <malloc+0x34>
  if(nu < 4096)
 6cf:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 6d5:	76 4d                	jbe    724 <malloc+0x9c>
 6d7:	89 d8                	mov    %ebx,%eax
 6d9:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 a0 fc ff ff       	call   383 <sbrk>
  if(p == (char*)-1)
 6e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e6:	74 18                	je     700 <malloc+0x78>
  hp->s.size = nu;
 6e8:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	83 c0 08             	add    $0x8,%eax
 6ee:	89 04 24             	mov    %eax,(%esp)
 6f1:	e8 12 ff ff ff       	call   608 <free>
  return freep;
 6f6:	8b 15 28 0a 00 00    	mov    0xa28,%edx
      if((p = morecore(nunits)) == 0)
 6fc:	85 d2                	test   %edx,%edx
 6fe:	75 bc                	jne    6bc <malloc+0x34>
        return 0;
 700:	31 c0                	xor    %eax,%eax
 702:	eb 18                	jmp    71c <malloc+0x94>
      if(p->s.size == nunits)
 704:	39 ce                	cmp    %ecx,%esi
 706:	74 28                	je     730 <malloc+0xa8>
        p->s.size -= nunits;
 708:	29 f1                	sub    %esi,%ecx
 70a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 70d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 710:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 713:	89 15 28 0a 00 00    	mov    %edx,0xa28
      return (void*)(p + 1);
 719:	83 c0 08             	add    $0x8,%eax
  }
}
 71c:	83 c4 1c             	add    $0x1c,%esp
 71f:	5b                   	pop    %ebx
 720:	5e                   	pop    %esi
 721:	5f                   	pop    %edi
 722:	5d                   	pop    %ebp
 723:	c3                   	ret    
  if(nu < 4096)
 724:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 729:	bf 00 10 00 00       	mov    $0x1000,%edi
 72e:	eb ab                	jmp    6db <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 730:	8b 08                	mov    (%eax),%ecx
 732:	89 0a                	mov    %ecx,(%edx)
 734:	eb dd                	jmp    713 <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 736:	c7 05 28 0a 00 00 2c 	movl   $0xa2c,0xa28
 73d:	0a 00 00 
 740:	c7 05 2c 0a 00 00 2c 	movl   $0xa2c,0xa2c
 747:	0a 00 00 
    base.s.size = 0;
 74a:	c7 05 30 0a 00 00 00 	movl   $0x0,0xa30
 751:	00 00 00 
 754:	b8 2c 0a 00 00       	mov    $0xa2c,%eax
 759:	e9 54 ff ff ff       	jmp    6b2 <malloc+0x2a>
