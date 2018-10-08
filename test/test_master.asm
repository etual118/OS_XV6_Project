
_test_master:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    {NOOP, 0, 0} },
};

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
  int pid;
  int i, j, k;
  for (i = 0; i < CNT_TEST; i++) {
   c:	31 ff                	xor    %edi,%edi
main(int argc, char *argv[])
   e:	8d 04 7f             	lea    (%edi,%edi,2),%eax
  11:	8d 04 80             	lea    (%eax,%eax,4),%eax
  14:	8d 1c c5 20 0a 00 00 	lea    0xa20(,%eax,8),%ebx
  1b:	31 f6                	xor    %esi,%esi
    k = 0;
    for (j = 0; j < CNT_CHILD; j++) {
      if (!strcmp(child_argv[i][j][0], NOOP))
  1d:	c7 44 24 04 16 07 00 	movl   $0x716,0x4(%esp)
  24:	00 
  25:	8b 03                	mov    (%ebx),%eax
  27:	89 04 24             	mov    %eax,(%esp)
  2a:	e8 cd 00 00 00       	call   fc <strcmp>
  2f:	85 c0                	test   %eax,%eax
  31:	0f 84 99 00 00 00    	je     d0 <main+0xd0>
        break;
      k++;
      pid = fork();
  37:	e8 67 02 00 00       	call   2a3 <fork>
      if (pid > 0) {
  3c:	83 f8 00             	cmp    $0x0,%eax
  3f:	7e 3b                	jle    7c <main+0x7c>
      k++;
  41:	46                   	inc    %esi
  42:	83 c3 0c             	add    $0xc,%ebx
    for (j = 0; j < CNT_CHILD; j++) {
  45:	83 fe 0a             	cmp    $0xa,%esi
  48:	75 d3                	jne    1d <main+0x1d>
      if (pid > 0) {
  4a:	31 db                	xor    %ebx,%ebx
        exit();
      }
    }

    for (j = 0; j < k; j++) {
      wait();
  4c:	e8 62 02 00 00       	call   2b3 <wait>
    for (j = 0; j < k; j++) {
  51:	43                   	inc    %ebx
  52:	39 f3                	cmp    %esi,%ebx
  54:	75 f6                	jne    4c <main+0x4c>
    }
    printf(1, "\n%d test done\n\n", i+1);
  56:	47                   	inc    %edi
  57:	89 7c 24 08          	mov    %edi,0x8(%esp)
  5b:	c7 44 24 04 1b 07 00 	movl   $0x71b,0x4(%esp)
  62:	00 
  63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6a:	e8 85 03 00 00       	call   3f4 <printf>
  for (i = 0; i < CNT_TEST; i++) {
  6f:	83 ff 0f             	cmp    $0xf,%edi
  72:	75 9a                	jne    e <main+0xe>
  }

  exit();
  74:	e8 32 02 00 00       	call   2ab <exit>
  79:	8d 76 00             	lea    0x0(%esi),%esi
      } else if (pid == 0) {
  7c:	75 39                	jne    b7 <main+0xb7>
        exec(child_argv[i][j][0], child_argv[i][j]);
  7e:	6b f6 0c             	imul   $0xc,%esi,%esi
  81:	6b ff 78             	imul   $0x78,%edi,%edi
  84:	01 fe                	add    %edi,%esi
  86:	8d 86 20 0a 00 00    	lea    0xa20(%esi),%eax
  8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  90:	8b 86 20 0a 00 00    	mov    0xa20(%esi),%eax
  96:	89 04 24             	mov    %eax,(%esp)
  99:	e8 45 02 00 00       	call   2e3 <exec>
        printf(1, "exec failed!!\n");
  9e:	c7 44 24 04 2b 07 00 	movl   $0x72b,0x4(%esp)
  a5:	00 
  a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ad:	e8 42 03 00 00       	call   3f4 <printf>
        exit();
  b2:	e8 f4 01 00 00       	call   2ab <exit>
        printf(1, "fork failed!!\n");
  b7:	c7 44 24 04 3a 07 00 	movl   $0x73a,0x4(%esp)
  be:	00 
  bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c6:	e8 29 03 00 00       	call   3f4 <printf>
        exit();
  cb:	e8 db 01 00 00       	call   2ab <exit>
    for (j = 0; j < k; j++) {
  d0:	85 f6                	test   %esi,%esi
  d2:	0f 85 72 ff ff ff    	jne    4a <main+0x4a>
  d8:	e9 79 ff ff ff       	jmp    56 <main+0x56>
  dd:	66 90                	xchg   %ax,%ax
  df:	90                   	nop

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 c2                	mov    %eax,%edx
  ec:	8a 19                	mov    (%ecx),%bl
  ee:	88 1a                	mov    %bl,(%edx)
  f0:	42                   	inc    %edx
  f1:	41                   	inc    %ecx
  f2:	84 db                	test   %bl,%bl
  f4:	75 f6                	jne    ec <strcpy+0xc>
    ;
  return os;
}
  f6:	5b                   	pop    %ebx
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    
  f9:	8d 76 00             	lea    0x0(%esi),%esi

000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	56                   	push   %esi
 100:	53                   	push   %ebx
 101:	8b 55 08             	mov    0x8(%ebp),%edx
 104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 107:	0f b6 02             	movzbl (%edx),%eax
 10a:	0f b6 19             	movzbl (%ecx),%ebx
 10d:	84 c0                	test   %al,%al
 10f:	75 14                	jne    125 <strcmp+0x29>
 111:	eb 1d                	jmp    130 <strcmp+0x34>
 113:	90                   	nop
    p++, q++;
 114:	42                   	inc    %edx
 115:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 118:	0f b6 02             	movzbl (%edx),%eax
 11b:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 11f:	84 c0                	test   %al,%al
 121:	74 0d                	je     130 <strcmp+0x34>
    p++, q++;
 123:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 125:	38 d8                	cmp    %bl,%al
 127:	74 eb                	je     114 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 129:	29 d8                	sub    %ebx,%eax
}
 12b:	5b                   	pop    %ebx
 12c:	5e                   	pop    %esi
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
 12f:	90                   	nop
  while(*p && *p == *q)
 130:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 132:	29 d8                	sub    %ebx,%eax
}
 134:	5b                   	pop    %ebx
 135:	5e                   	pop    %esi
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    

00000138 <strlen>:

uint
strlen(char *s)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 13e:	80 39 00             	cmpb   $0x0,(%ecx)
 141:	74 10                	je     153 <strlen+0x1b>
 143:	31 d2                	xor    %edx,%edx
 145:	8d 76 00             	lea    0x0(%esi),%esi
 148:	42                   	inc    %edx
 149:	89 d0                	mov    %edx,%eax
 14b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 14f:	75 f7                	jne    148 <strlen+0x10>
    ;
  return n;
}
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    
  for(n = 0; s[n]; n++)
 153:	31 c0                	xor    %eax,%eax
}
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	90                   	nop

00000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	57                   	push   %edi
 15c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 15f:	89 d7                	mov    %edx,%edi
 161:	8b 4d 10             	mov    0x10(%ebp),%ecx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	fc                   	cld    
 168:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 16a:	89 d0                	mov    %edx,%eax
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    
 16f:	90                   	nop

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 179:	8a 10                	mov    (%eax),%dl
 17b:	84 d2                	test   %dl,%dl
 17d:	75 0c                	jne    18b <strchr+0x1b>
 17f:	eb 13                	jmp    194 <strchr+0x24>
 181:	8d 76 00             	lea    0x0(%esi),%esi
 184:	40                   	inc    %eax
 185:	8a 10                	mov    (%eax),%dl
 187:	84 d2                	test   %dl,%dl
 189:	74 09                	je     194 <strchr+0x24>
    if(*s == c)
 18b:	38 ca                	cmp    %cl,%dl
 18d:	75 f5                	jne    184 <strchr+0x14>
      return (char*)s;
  return 0;
}
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 194:	31 c0                	xor    %eax,%eax
}
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	57                   	push   %edi
 19c:	56                   	push   %esi
 19d:	53                   	push   %ebx
 19e:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1a3:	8d 7d e7             	lea    -0x19(%ebp),%edi
 1a6:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 1a8:	8d 73 01             	lea    0x1(%ebx),%esi
 1ab:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1ae:	7d 40                	jge    1f0 <gets+0x58>
    cc = read(0, &c, 1);
 1b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b7:	00 
 1b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c3:	e8 fb 00 00 00       	call   2c3 <read>
    if(cc < 1)
 1c8:	85 c0                	test   %eax,%eax
 1ca:	7e 24                	jle    1f0 <gets+0x58>
      break;
    buf[i++] = c;
 1cc:	8a 45 e7             	mov    -0x19(%ebp),%al
 1cf:	8b 55 08             	mov    0x8(%ebp),%edx
 1d2:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 1d6:	3c 0a                	cmp    $0xa,%al
 1d8:	74 06                	je     1e0 <gets+0x48>
 1da:	89 f3                	mov    %esi,%ebx
 1dc:	3c 0d                	cmp    $0xd,%al
 1de:	75 c8                	jne    1a8 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1e7:	83 c4 2c             	add    $0x2c,%esp
 1ea:	5b                   	pop    %ebx
 1eb:	5e                   	pop    %esi
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret    
 1ef:	90                   	nop
    if(cc < 1)
 1f0:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1f9:	83 c4 2c             	add    $0x2c,%esp
 1fc:	5b                   	pop    %ebx
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	8d 76 00             	lea    0x0(%esi),%esi

00000204 <stat>:

int
stat(char *n, struct stat *st)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	56                   	push   %esi
 208:	53                   	push   %ebx
 209:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 213:	00 
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	89 04 24             	mov    %eax,(%esp)
 21a:	e8 cc 00 00 00       	call   2eb <open>
 21f:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 221:	85 c0                	test   %eax,%eax
 223:	78 23                	js     248 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	89 44 24 04          	mov    %eax,0x4(%esp)
 22c:	89 1c 24             	mov    %ebx,(%esp)
 22f:	e8 cf 00 00 00       	call   303 <fstat>
 234:	89 c6                	mov    %eax,%esi
  close(fd);
 236:	89 1c 24             	mov    %ebx,(%esp)
 239:	e8 95 00 00 00       	call   2d3 <close>
  return r;
}
 23e:	89 f0                	mov    %esi,%eax
 240:	83 c4 10             	add    $0x10,%esp
 243:	5b                   	pop    %ebx
 244:	5e                   	pop    %esi
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    
 247:	90                   	nop
    return -1;
 248:	be ff ff ff ff       	mov    $0xffffffff,%esi
 24d:	eb ef                	jmp    23e <stat+0x3a>
 24f:	90                   	nop

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 11             	movsbl (%ecx),%edx
 25a:	8d 42 d0             	lea    -0x30(%edx),%eax
 25d:	3c 09                	cmp    $0x9,%al
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
 264:	77 15                	ja     27b <atoi+0x2b>
 266:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 268:	8d 04 80             	lea    (%eax,%eax,4),%eax
 26b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 26f:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 270:	0f be 11             	movsbl (%ecx),%edx
 273:	8d 5a d0             	lea    -0x30(%edx),%ebx
 276:	80 fb 09             	cmp    $0x9,%bl
 279:	76 ed                	jbe    268 <atoi+0x18>
  return n;
}
 27b:	5b                   	pop    %ebx
 27c:	5d                   	pop    %ebp
 27d:	c3                   	ret    
 27e:	66 90                	xchg   %ax,%ax

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 28b:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 28e:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 290:	85 f6                	test   %esi,%esi
 292:	7e 0b                	jle    29f <memmove+0x1f>
    *dst++ = *src++;
 294:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 297:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 29a:	42                   	inc    %edx
  while(n-- > 0)
 29b:	39 f2                	cmp    %esi,%edx
 29d:	75 f5                	jne    294 <memmove+0x14>
  return vdst;
}
 29f:	5b                   	pop    %ebx
 2a0:	5e                   	pop    %esi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    

000002a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a3:	b8 01 00 00 00       	mov    $0x1,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <exit>:
SYSCALL(exit)
 2ab:	b8 02 00 00 00       	mov    $0x2,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <wait>:
SYSCALL(wait)
 2b3:	b8 03 00 00 00       	mov    $0x3,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <pipe>:
SYSCALL(pipe)
 2bb:	b8 04 00 00 00       	mov    $0x4,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <read>:
SYSCALL(read)
 2c3:	b8 05 00 00 00       	mov    $0x5,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <write>:
SYSCALL(write)
 2cb:	b8 10 00 00 00       	mov    $0x10,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <close>:
SYSCALL(close)
 2d3:	b8 15 00 00 00       	mov    $0x15,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <kill>:
SYSCALL(kill)
 2db:	b8 06 00 00 00       	mov    $0x6,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <exec>:
SYSCALL(exec)
 2e3:	b8 07 00 00 00       	mov    $0x7,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <open>:
SYSCALL(open)
 2eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <mknod>:
SYSCALL(mknod)
 2f3:	b8 11 00 00 00       	mov    $0x11,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <unlink>:
SYSCALL(unlink)
 2fb:	b8 12 00 00 00       	mov    $0x12,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <fstat>:
SYSCALL(fstat)
 303:	b8 08 00 00 00       	mov    $0x8,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <link>:
SYSCALL(link)
 30b:	b8 13 00 00 00       	mov    $0x13,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mkdir>:
SYSCALL(mkdir)
 313:	b8 14 00 00 00       	mov    $0x14,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <chdir>:
SYSCALL(chdir)
 31b:	b8 09 00 00 00       	mov    $0x9,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <dup>:
SYSCALL(dup)
 323:	b8 0a 00 00 00       	mov    $0xa,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <getpid>:
SYSCALL(getpid)
 32b:	b8 0b 00 00 00       	mov    $0xb,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getppid>:
SYSCALL(getppid)
 333:	b8 17 00 00 00       	mov    $0x17,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <myfunction>:
SYSCALL(myfunction)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <yield>:
SYSCALL(yield)
 35b:	b8 18 00 00 00       	mov    $0x18,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <getlev>:
SYSCALL(getlev)
 363:	b8 19 00 00 00       	mov    $0x19,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <set_cpu_share>:
 36b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    
 373:	90                   	nop

00000374 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	56                   	push   %esi
 379:	53                   	push   %ebx
 37a:	83 ec 3c             	sub    $0x3c,%esp
 37d:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 37f:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 381:	8b 5d 08             	mov    0x8(%ebp),%ebx
 384:	85 db                	test   %ebx,%ebx
 386:	74 04                	je     38c <printint+0x18>
 388:	85 d2                	test   %edx,%edx
 38a:	78 5d                	js     3e9 <printint+0x75>
  neg = 0;
 38c:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 38e:	31 f6                	xor    %esi,%esi
 390:	eb 04                	jmp    396 <printint+0x22>
 392:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 394:	89 d6                	mov    %edx,%esi
 396:	31 d2                	xor    %edx,%edx
 398:	f7 f1                	div    %ecx
 39a:	8a 92 89 07 00 00    	mov    0x789(%edx),%dl
 3a0:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 3a4:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 3a7:	85 c0                	test   %eax,%eax
 3a9:	75 e9                	jne    394 <printint+0x20>
  if(neg)
 3ab:	85 db                	test   %ebx,%ebx
 3ad:	74 08                	je     3b7 <printint+0x43>
    buf[i++] = '-';
 3af:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 3b4:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 3b7:	8d 5a ff             	lea    -0x1(%edx),%ebx
 3ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 3c4:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3c7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ce:	00 
 3cf:	89 74 24 04          	mov    %esi,0x4(%esp)
 3d3:	89 3c 24             	mov    %edi,(%esp)
 3d6:	e8 f0 fe ff ff       	call   2cb <write>
  while(--i >= 0)
 3db:	4b                   	dec    %ebx
 3dc:	83 fb ff             	cmp    $0xffffffff,%ebx
 3df:	75 df                	jne    3c0 <printint+0x4c>
    putc(fd, buf[i]);
}
 3e1:	83 c4 3c             	add    $0x3c,%esp
 3e4:	5b                   	pop    %ebx
 3e5:	5e                   	pop    %esi
 3e6:	5f                   	pop    %edi
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    
    x = -xx;
 3e9:	f7 d8                	neg    %eax
    neg = 1;
 3eb:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 3f0:	eb 9c                	jmp    38e <printint+0x1a>
 3f2:	66 90                	xchg   %ax,%ax

000003f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	57                   	push   %edi
 3f8:	56                   	push   %esi
 3f9:	53                   	push   %ebx
 3fa:	83 ec 3c             	sub    $0x3c,%esp
 3fd:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 403:	8a 03                	mov    (%ebx),%al
 405:	84 c0                	test   %al,%al
 407:	0f 84 bb 00 00 00    	je     4c8 <printf+0xd4>
printf(int fd, char *fmt, ...)
 40d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 40e:	8d 55 10             	lea    0x10(%ebp),%edx
 411:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 414:	31 ff                	xor    %edi,%edi
 416:	eb 2f                	jmp    447 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 418:	83 f9 25             	cmp    $0x25,%ecx
 41b:	0f 84 af 00 00 00    	je     4d0 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 421:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 424:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42b:	00 
 42c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 42f:	89 44 24 04          	mov    %eax,0x4(%esp)
 433:	89 34 24             	mov    %esi,(%esp)
 436:	e8 90 fe ff ff       	call   2cb <write>
 43b:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 43c:	8a 43 ff             	mov    -0x1(%ebx),%al
 43f:	84 c0                	test   %al,%al
 441:	0f 84 81 00 00 00    	je     4c8 <printf+0xd4>
    c = fmt[i] & 0xff;
 447:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 44a:	85 ff                	test   %edi,%edi
 44c:	74 ca                	je     418 <printf+0x24>
      }
    } else if(state == '%'){
 44e:	83 ff 25             	cmp    $0x25,%edi
 451:	75 e8                	jne    43b <printf+0x47>
      if(c == 'd'){
 453:	83 f9 64             	cmp    $0x64,%ecx
 456:	0f 84 14 01 00 00    	je     570 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45c:	83 f9 78             	cmp    $0x78,%ecx
 45f:	74 7b                	je     4dc <printf+0xe8>
 461:	83 f9 70             	cmp    $0x70,%ecx
 464:	74 76                	je     4dc <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 466:	83 f9 73             	cmp    $0x73,%ecx
 469:	0f 84 91 00 00 00    	je     500 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46f:	83 f9 63             	cmp    $0x63,%ecx
 472:	0f 84 cc 00 00 00    	je     544 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 478:	83 f9 25             	cmp    $0x25,%ecx
 47b:	0f 84 13 01 00 00    	je     594 <printf+0x1a0>
 481:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 485:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48c:	00 
 48d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 490:	89 44 24 04          	mov    %eax,0x4(%esp)
 494:	89 34 24             	mov    %esi,(%esp)
 497:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 49a:	e8 2c fe ff ff       	call   2cb <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 49f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 4a2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 4a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ac:	00 
 4ad:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4b0:	89 54 24 04          	mov    %edx,0x4(%esp)
 4b4:	89 34 24             	mov    %esi,(%esp)
 4b7:	e8 0f fe ff ff       	call   2cb <write>
      }
      state = 0;
 4bc:	31 ff                	xor    %edi,%edi
 4be:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 4bf:	8a 43 ff             	mov    -0x1(%ebx),%al
 4c2:	84 c0                	test   %al,%al
 4c4:	75 81                	jne    447 <printf+0x53>
 4c6:	66 90                	xchg   %ax,%ax
    }
  }
}
 4c8:	83 c4 3c             	add    $0x3c,%esp
 4cb:	5b                   	pop    %ebx
 4cc:	5e                   	pop    %esi
 4cd:	5f                   	pop    %edi
 4ce:	5d                   	pop    %ebp
 4cf:	c3                   	ret    
        state = '%';
 4d0:	bf 25 00 00 00       	mov    $0x25,%edi
 4d5:	e9 61 ff ff ff       	jmp    43b <printf+0x47>
 4da:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4eb:	8b 10                	mov    (%eax),%edx
 4ed:	89 f0                	mov    %esi,%eax
 4ef:	e8 80 fe ff ff       	call   374 <printint>
        ap++;
 4f4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4f8:	31 ff                	xor    %edi,%edi
        ap++;
 4fa:	e9 3c ff ff ff       	jmp    43b <printf+0x47>
 4ff:	90                   	nop
        s = (char*)*ap;
 500:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 503:	8b 3a                	mov    (%edx),%edi
        ap++;
 505:	83 c2 04             	add    $0x4,%edx
 508:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 50b:	85 ff                	test   %edi,%edi
 50d:	0f 84 a3 00 00 00    	je     5b6 <printf+0x1c2>
        while(*s != 0){
 513:	8a 07                	mov    (%edi),%al
 515:	84 c0                	test   %al,%al
 517:	74 24                	je     53d <printf+0x149>
 519:	8d 76 00             	lea    0x0(%esi),%esi
 51c:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 51f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 526:	00 
 527:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	89 34 24             	mov    %esi,(%esp)
 531:	e8 95 fd ff ff       	call   2cb <write>
          s++;
 536:	47                   	inc    %edi
        while(*s != 0){
 537:	8a 07                	mov    (%edi),%al
 539:	84 c0                	test   %al,%al
 53b:	75 df                	jne    51c <printf+0x128>
      state = 0;
 53d:	31 ff                	xor    %edi,%edi
 53f:	e9 f7 fe ff ff       	jmp    43b <printf+0x47>
        putc(fd, *ap);
 544:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 547:	8b 02                	mov    (%edx),%eax
 549:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 54c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 553:	00 
 554:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	89 34 24             	mov    %esi,(%esp)
 55e:	e8 68 fd ff ff       	call   2cb <write>
        ap++;
 563:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 567:	31 ff                	xor    %edi,%edi
 569:	e9 cd fe ff ff       	jmp    43b <printf+0x47>
 56e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 570:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 577:	b1 0a                	mov    $0xa,%cl
 579:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 57c:	8b 10                	mov    (%eax),%edx
 57e:	89 f0                	mov    %esi,%eax
 580:	e8 ef fd ff ff       	call   374 <printint>
        ap++;
 585:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 589:	66 31 ff             	xor    %di,%di
 58c:	e9 aa fe ff ff       	jmp    43b <printf+0x47>
 591:	8d 76 00             	lea    0x0(%esi),%esi
 594:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 598:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59f:	00 
 5a0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a7:	89 34 24             	mov    %esi,(%esp)
 5aa:	e8 1c fd ff ff       	call   2cb <write>
      state = 0;
 5af:	31 ff                	xor    %edi,%edi
 5b1:	e9 85 fe ff ff       	jmp    43b <printf+0x47>
          s = "(null)";
 5b6:	bf 82 07 00 00       	mov    $0x782,%edi
 5bb:	e9 53 ff ff ff       	jmp    513 <printf+0x11f>

000005c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c9:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cc:	a1 28 11 00 00       	mov    0x1128,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d1:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d3:	39 d0                	cmp    %edx,%eax
 5d5:	72 11                	jb     5e8 <free+0x28>
 5d7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d8:	39 c8                	cmp    %ecx,%eax
 5da:	72 04                	jb     5e0 <free+0x20>
 5dc:	39 ca                	cmp    %ecx,%edx
 5de:	72 10                	jb     5f0 <free+0x30>
 5e0:	89 c8                	mov    %ecx,%eax
 5e2:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e4:	39 d0                	cmp    %edx,%eax
 5e6:	73 f0                	jae    5d8 <free+0x18>
 5e8:	39 ca                	cmp    %ecx,%edx
 5ea:	72 04                	jb     5f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ec:	39 c8                	cmp    %ecx,%eax
 5ee:	72 f0                	jb     5e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5f6:	39 cf                	cmp    %ecx,%edi
 5f8:	74 1a                	je     614 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5fa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5fd:	8b 48 04             	mov    0x4(%eax),%ecx
 600:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 603:	39 f2                	cmp    %esi,%edx
 605:	74 24                	je     62b <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 607:	89 10                	mov    %edx,(%eax)
  freep = p;
 609:	a3 28 11 00 00       	mov    %eax,0x1128
}
 60e:	5b                   	pop    %ebx
 60f:	5e                   	pop    %esi
 610:	5f                   	pop    %edi
 611:	5d                   	pop    %ebp
 612:	c3                   	ret    
 613:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 614:	03 71 04             	add    0x4(%ecx),%esi
 617:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61a:	8b 08                	mov    (%eax),%ecx
 61c:	8b 09                	mov    (%ecx),%ecx
 61e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 621:	8b 48 04             	mov    0x4(%eax),%ecx
 624:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 627:	39 f2                	cmp    %esi,%edx
 629:	75 dc                	jne    607 <free+0x47>
    p->s.size += bp->s.size;
 62b:	03 4b fc             	add    -0x4(%ebx),%ecx
 62e:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 631:	8b 53 f8             	mov    -0x8(%ebx),%edx
 634:	89 10                	mov    %edx,(%eax)
  freep = p;
 636:	a3 28 11 00 00       	mov    %eax,0x1128
}
 63b:	5b                   	pop    %ebx
 63c:	5e                   	pop    %esi
 63d:	5f                   	pop    %edi
 63e:	5d                   	pop    %ebp
 63f:	c3                   	ret    

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 75 08             	mov    0x8(%ebp),%esi
 64c:	83 c6 07             	add    $0x7,%esi
 64f:	c1 ee 03             	shr    $0x3,%esi
 652:	46                   	inc    %esi
  if((prevp = freep) == 0){
 653:	8b 15 28 11 00 00    	mov    0x1128,%edx
 659:	85 d2                	test   %edx,%edx
 65b:	0f 84 8d 00 00 00    	je     6ee <malloc+0xae>
 661:	8b 02                	mov    (%edx),%eax
 663:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 666:	39 ce                	cmp    %ecx,%esi
 668:	76 52                	jbe    6bc <malloc+0x7c>
 66a:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 671:	eb 0a                	jmp    67d <malloc+0x3d>
 673:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 674:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 676:	8b 48 04             	mov    0x4(%eax),%ecx
 679:	39 ce                	cmp    %ecx,%esi
 67b:	76 3f                	jbe    6bc <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 67d:	89 c2                	mov    %eax,%edx
 67f:	3b 05 28 11 00 00    	cmp    0x1128,%eax
 685:	75 ed                	jne    674 <malloc+0x34>
  if(nu < 4096)
 687:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 68d:	76 4d                	jbe    6dc <malloc+0x9c>
 68f:	89 d8                	mov    %ebx,%eax
 691:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 a0 fc ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 69b:	83 f8 ff             	cmp    $0xffffffff,%eax
 69e:	74 18                	je     6b8 <malloc+0x78>
  hp->s.size = nu;
 6a0:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6a3:	83 c0 08             	add    $0x8,%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 12 ff ff ff       	call   5c0 <free>
  return freep;
 6ae:	8b 15 28 11 00 00    	mov    0x1128,%edx
      if((p = morecore(nunits)) == 0)
 6b4:	85 d2                	test   %edx,%edx
 6b6:	75 bc                	jne    674 <malloc+0x34>
        return 0;
 6b8:	31 c0                	xor    %eax,%eax
 6ba:	eb 18                	jmp    6d4 <malloc+0x94>
      if(p->s.size == nunits)
 6bc:	39 ce                	cmp    %ecx,%esi
 6be:	74 28                	je     6e8 <malloc+0xa8>
        p->s.size -= nunits;
 6c0:	29 f1                	sub    %esi,%ecx
 6c2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6c5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6c8:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6cb:	89 15 28 11 00 00    	mov    %edx,0x1128
      return (void*)(p + 1);
 6d1:	83 c0 08             	add    $0x8,%eax
  }
}
 6d4:	83 c4 1c             	add    $0x1c,%esp
 6d7:	5b                   	pop    %ebx
 6d8:	5e                   	pop    %esi
 6d9:	5f                   	pop    %edi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
  if(nu < 4096)
 6dc:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 6e1:	bf 00 10 00 00       	mov    $0x1000,%edi
 6e6:	eb ab                	jmp    693 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 6e8:	8b 08                	mov    (%eax),%ecx
 6ea:	89 0a                	mov    %ecx,(%edx)
 6ec:	eb dd                	jmp    6cb <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 6ee:	c7 05 28 11 00 00 2c 	movl   $0x112c,0x1128
 6f5:	11 00 00 
 6f8:	c7 05 2c 11 00 00 2c 	movl   $0x112c,0x112c
 6ff:	11 00 00 
    base.s.size = 0;
 702:	c7 05 30 11 00 00 00 	movl   $0x0,0x1130
 709:	00 00 00 
 70c:	b8 2c 11 00 00       	mov    $0x112c,%eax
 711:	e9 54 ff ff ff       	jmp    66a <malloc+0x2a>
