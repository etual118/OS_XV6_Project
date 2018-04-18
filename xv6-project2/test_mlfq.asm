
_test_mlfq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Number of level(priority) of MLFQ scheduler
#define MLFQ_LEVEL      3

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 30             	sub    $0x30,%esp
    uint i;
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
   c:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  13:	00 
  14:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  1b:	00 
  1c:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  23:	00 
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
  24:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  28:	0f 8e 8b 00 00 00    	jle    b9 <main+0xb9>
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
        exit();
    }

    do_yield = atoi(argv[1]);
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	8b 40 04             	mov    0x4(%eax),%eax
  34:	89 04 24             	mov    %eax,(%esp)
  37:	e8 08 02 00 00       	call   244 <atoi>
  3c:	89 c7                	mov    %eax,%edi

    i = 0;
  3e:	31 db                	xor    %ebx,%ebx
        i++;
        
        // Prevent code optimization
        __sync_synchronize();

        if (i % YIELD_PERIOD == 0) {
  40:	be 10 27 00 00       	mov    $0x2710,%esi
  45:	8d 76 00             	lea    0x0(%esi),%esi
        i++;
  48:	43                   	inc    %ebx
        __sync_synchronize();
  49:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
        if (i % YIELD_PERIOD == 0) {
  4e:	89 d8                	mov    %ebx,%eax
  50:	31 d2                	xor    %edx,%edx
  52:	f7 f6                	div    %esi
  54:	85 d2                	test   %edx,%edx
  56:	75 f0                	jne    48 <main+0x48>
            // Get current MLFQ level(priority) of this process
            curr_mlfq_level = getlev();
  58:	e8 fa 02 00 00       	call   357 <getlev>
            cnt_level[curr_mlfq_level]++;
  5d:	ff 44 84 24          	incl   0x24(%esp,%eax,4)

            if (i > LIFETIME) {
  61:	81 fb 00 c2 eb 0b    	cmp    $0xbebc200,%ebx
  67:	77 0b                	ja     74 <main+0x74>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
            }

            if (do_yield) {
  69:	85 ff                	test   %edi,%edi
  6b:	74 db                	je     48 <main+0x48>
                // Yield process itself, not by timer interrupt
                yield();
  6d:	e8 dd 02 00 00       	call   34f <yield>
  72:	eb d4                	jmp    48 <main+0x48>
                printf(1, "MLFQ(%s), lev[0]: %d, lev[1]: %d, lev[2]: %d\n",
  74:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  78:	8b 54 24 28          	mov    0x28(%esp),%edx
  7c:	8b 44 24 24          	mov    0x24(%esp),%eax
  80:	85 ff                	test   %edi,%edi
  82:	74 2e                	je     b2 <main+0xb2>
  84:	bb 14 07 00 00       	mov    $0x714,%ebx
  89:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8d:	89 54 24 10          	mov    %edx,0x10(%esp)
  91:	89 44 24 0c          	mov    %eax,0xc(%esp)
  95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  99:	c7 44 24 04 4c 07 00 	movl   $0x74c,0x4(%esp)
  a0:	00 
  a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a8:	e8 3b 03 00 00       	call   3e8 <printf>
            }
        }
    }

    exit();
  ad:	e8 ed 01 00 00       	call   29f <exit>
                printf(1, "MLFQ(%s), lev[0]: %d, lev[1]: %d, lev[2]: %d\n",
  b2:	bb 0c 07 00 00       	mov    $0x70c,%ebx
  b7:	eb d0                	jmp    89 <main+0x89>
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
  b9:	c7 44 24 04 1c 07 00 	movl   $0x71c,0x4(%esp)
  c0:	00 
  c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c8:	e8 1b 03 00 00       	call   3e8 <printf>
        exit();
  cd:	e8 cd 01 00 00       	call   29f <exit>
  d2:	66 90                	xchg   %ax,%ax

000000d4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	53                   	push   %ebx
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  de:	89 c2                	mov    %eax,%edx
  e0:	8a 19                	mov    (%ecx),%bl
  e2:	88 1a                	mov    %bl,(%edx)
  e4:	42                   	inc    %edx
  e5:	41                   	inc    %ecx
  e6:	84 db                	test   %bl,%bl
  e8:	75 f6                	jne    e0 <strcpy+0xc>
    ;
  return os;
}
  ea:	5b                   	pop    %ebx
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    
  ed:	8d 76 00             	lea    0x0(%esi),%esi

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	8b 55 08             	mov    0x8(%ebp),%edx
  f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  fb:	0f b6 02             	movzbl (%edx),%eax
  fe:	0f b6 19             	movzbl (%ecx),%ebx
 101:	84 c0                	test   %al,%al
 103:	75 14                	jne    119 <strcmp+0x29>
 105:	eb 1d                	jmp    124 <strcmp+0x34>
 107:	90                   	nop
    p++, q++;
 108:	42                   	inc    %edx
 109:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 10c:	0f b6 02             	movzbl (%edx),%eax
 10f:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 113:	84 c0                	test   %al,%al
 115:	74 0d                	je     124 <strcmp+0x34>
    p++, q++;
 117:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 119:	38 d8                	cmp    %bl,%al
 11b:	74 eb                	je     108 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 11d:	29 d8                	sub    %ebx,%eax
}
 11f:	5b                   	pop    %ebx
 120:	5e                   	pop    %esi
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    
 123:	90                   	nop
  while(*p && *p == *q)
 124:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 126:	29 d8                	sub    %ebx,%eax
}
 128:	5b                   	pop    %ebx
 129:	5e                   	pop    %esi
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <strlen>:

uint
strlen(char *s)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 132:	80 39 00             	cmpb   $0x0,(%ecx)
 135:	74 10                	je     147 <strlen+0x1b>
 137:	31 d2                	xor    %edx,%edx
 139:	8d 76 00             	lea    0x0(%esi),%esi
 13c:	42                   	inc    %edx
 13d:	89 d0                	mov    %edx,%eax
 13f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 143:	75 f7                	jne    13c <strlen+0x10>
    ;
  return n;
}
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    
  for(n = 0; s[n]; n++)
 147:	31 c0                	xor    %eax,%eax
}
 149:	5d                   	pop    %ebp
 14a:	c3                   	ret    
 14b:	90                   	nop

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	57                   	push   %edi
 150:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 153:	89 d7                	mov    %edx,%edi
 155:	8b 4d 10             	mov    0x10(%ebp),%ecx
 158:	8b 45 0c             	mov    0xc(%ebp),%eax
 15b:	fc                   	cld    
 15c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 15e:	89 d0                	mov    %edx,%eax
 160:	5f                   	pop    %edi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	90                   	nop

00000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 16d:	8a 10                	mov    (%eax),%dl
 16f:	84 d2                	test   %dl,%dl
 171:	75 0c                	jne    17f <strchr+0x1b>
 173:	eb 13                	jmp    188 <strchr+0x24>
 175:	8d 76 00             	lea    0x0(%esi),%esi
 178:	40                   	inc    %eax
 179:	8a 10                	mov    (%eax),%dl
 17b:	84 d2                	test   %dl,%dl
 17d:	74 09                	je     188 <strchr+0x24>
    if(*s == c)
 17f:	38 ca                	cmp    %cl,%dl
 181:	75 f5                	jne    178 <strchr+0x14>
      return (char*)s;
  return 0;
}
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 188:	31 c0                	xor    %eax,%eax
}
 18a:	5d                   	pop    %ebp
 18b:	c3                   	ret    

0000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
 190:	56                   	push   %esi
 191:	53                   	push   %ebx
 192:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 195:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 197:	8d 7d e7             	lea    -0x19(%ebp),%edi
 19a:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 19c:	8d 73 01             	lea    0x1(%ebx),%esi
 19f:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1a2:	7d 40                	jge    1e4 <gets+0x58>
    cc = read(0, &c, 1);
 1a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ab:	00 
 1ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b7:	e8 fb 00 00 00       	call   2b7 <read>
    if(cc < 1)
 1bc:	85 c0                	test   %eax,%eax
 1be:	7e 24                	jle    1e4 <gets+0x58>
      break;
    buf[i++] = c;
 1c0:	8a 45 e7             	mov    -0x19(%ebp),%al
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
 1c6:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 1ca:	3c 0a                	cmp    $0xa,%al
 1cc:	74 06                	je     1d4 <gets+0x48>
 1ce:	89 f3                	mov    %esi,%ebx
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	75 c8                	jne    19c <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1db:	83 c4 2c             	add    $0x2c,%esp
 1de:	5b                   	pop    %ebx
 1df:	5e                   	pop    %esi
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	90                   	nop
    if(cc < 1)
 1e4:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1ed:	83 c4 2c             	add    $0x2c,%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    
 1f5:	8d 76 00             	lea    0x0(%esi),%esi

000001f8 <stat>:

int
stat(char *n, struct stat *st)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	56                   	push   %esi
 1fc:	53                   	push   %ebx
 1fd:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 200:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 207:	00 
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	89 04 24             	mov    %eax,(%esp)
 20e:	e8 cc 00 00 00       	call   2df <open>
 213:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 215:	85 c0                	test   %eax,%eax
 217:	78 23                	js     23c <stat+0x44>
    return -1;
  r = fstat(fd, st);
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	89 44 24 04          	mov    %eax,0x4(%esp)
 220:	89 1c 24             	mov    %ebx,(%esp)
 223:	e8 cf 00 00 00       	call   2f7 <fstat>
 228:	89 c6                	mov    %eax,%esi
  close(fd);
 22a:	89 1c 24             	mov    %ebx,(%esp)
 22d:	e8 95 00 00 00       	call   2c7 <close>
  return r;
}
 232:	89 f0                	mov    %esi,%eax
 234:	83 c4 10             	add    $0x10,%esp
 237:	5b                   	pop    %ebx
 238:	5e                   	pop    %esi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    
 23b:	90                   	nop
    return -1;
 23c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 241:	eb ef                	jmp    232 <stat+0x3a>
 243:	90                   	nop

00000244 <atoi>:

int
atoi(const char *s)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	53                   	push   %ebx
 248:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24b:	0f be 11             	movsbl (%ecx),%edx
 24e:	8d 42 d0             	lea    -0x30(%edx),%eax
 251:	3c 09                	cmp    $0x9,%al
 253:	b8 00 00 00 00       	mov    $0x0,%eax
 258:	77 15                	ja     26f <atoi+0x2b>
 25a:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 25c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 25f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 263:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 264:	0f be 11             	movsbl (%ecx),%edx
 267:	8d 5a d0             	lea    -0x30(%edx),%ebx
 26a:	80 fb 09             	cmp    $0x9,%bl
 26d:	76 ed                	jbe    25c <atoi+0x18>
  return n;
}
 26f:	5b                   	pop    %ebx
 270:	5d                   	pop    %ebp
 271:	c3                   	ret    
 272:	66 90                	xchg   %ax,%ax

00000274 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	56                   	push   %esi
 278:	53                   	push   %ebx
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27f:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 282:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 284:	85 f6                	test   %esi,%esi
 286:	7e 0b                	jle    293 <memmove+0x1f>
    *dst++ = *src++;
 288:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 28b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28e:	42                   	inc    %edx
  while(n-- > 0)
 28f:	39 f2                	cmp    %esi,%edx
 291:	75 f5                	jne    288 <memmove+0x14>
  return vdst;
}
 293:	5b                   	pop    %ebx
 294:	5e                   	pop    %esi
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    

00000297 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 297:	b8 01 00 00 00       	mov    $0x1,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <exit>:
SYSCALL(exit)
 29f:	b8 02 00 00 00       	mov    $0x2,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <wait>:
SYSCALL(wait)
 2a7:	b8 03 00 00 00       	mov    $0x3,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <pipe>:
SYSCALL(pipe)
 2af:	b8 04 00 00 00       	mov    $0x4,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <read>:
SYSCALL(read)
 2b7:	b8 05 00 00 00       	mov    $0x5,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <write>:
SYSCALL(write)
 2bf:	b8 10 00 00 00       	mov    $0x10,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <close>:
SYSCALL(close)
 2c7:	b8 15 00 00 00       	mov    $0x15,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <kill>:
SYSCALL(kill)
 2cf:	b8 06 00 00 00       	mov    $0x6,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <exec>:
SYSCALL(exec)
 2d7:	b8 07 00 00 00       	mov    $0x7,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <open>:
SYSCALL(open)
 2df:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <mknod>:
SYSCALL(mknod)
 2e7:	b8 11 00 00 00       	mov    $0x11,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <unlink>:
SYSCALL(unlink)
 2ef:	b8 12 00 00 00       	mov    $0x12,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <fstat>:
SYSCALL(fstat)
 2f7:	b8 08 00 00 00       	mov    $0x8,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <link>:
SYSCALL(link)
 2ff:	b8 13 00 00 00       	mov    $0x13,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <mkdir>:
SYSCALL(mkdir)
 307:	b8 14 00 00 00       	mov    $0x14,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <chdir>:
SYSCALL(chdir)
 30f:	b8 09 00 00 00       	mov    $0x9,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <dup>:
SYSCALL(dup)
 317:	b8 0a 00 00 00       	mov    $0xa,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <getpid>:
SYSCALL(getpid)
 31f:	b8 0b 00 00 00       	mov    $0xb,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <getppid>:
SYSCALL(getppid)
 327:	b8 17 00 00 00       	mov    $0x17,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <sbrk>:
SYSCALL(sbrk)
 32f:	b8 0c 00 00 00       	mov    $0xc,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sleep>:
SYSCALL(sleep)
 337:	b8 0d 00 00 00       	mov    $0xd,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <uptime>:
SYSCALL(uptime)
 33f:	b8 0e 00 00 00       	mov    $0xe,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <myfunction>:
SYSCALL(myfunction)
 347:	b8 16 00 00 00       	mov    $0x16,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <yield>:
SYSCALL(yield)
 34f:	b8 18 00 00 00       	mov    $0x18,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <getlev>:
SYSCALL(getlev)
 357:	b8 19 00 00 00       	mov    $0x19,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <set_cpu_share>:
 35f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    
 367:	90                   	nop

00000368 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 3c             	sub    $0x3c,%esp
 371:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 373:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 375:	8b 5d 08             	mov    0x8(%ebp),%ebx
 378:	85 db                	test   %ebx,%ebx
 37a:	74 04                	je     380 <printint+0x18>
 37c:	85 d2                	test   %edx,%edx
 37e:	78 5d                	js     3dd <printint+0x75>
  neg = 0;
 380:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 382:	31 f6                	xor    %esi,%esi
 384:	eb 04                	jmp    38a <printint+0x22>
 386:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 388:	89 d6                	mov    %edx,%esi
 38a:	31 d2                	xor    %edx,%edx
 38c:	f7 f1                	div    %ecx
 38e:	8a 92 83 07 00 00    	mov    0x783(%edx),%dl
 394:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 398:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 39b:	85 c0                	test   %eax,%eax
 39d:	75 e9                	jne    388 <printint+0x20>
  if(neg)
 39f:	85 db                	test   %ebx,%ebx
 3a1:	74 08                	je     3ab <printint+0x43>
    buf[i++] = '-';
 3a3:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 3a8:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 3ab:	8d 5a ff             	lea    -0x1(%edx),%ebx
 3ae:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3b1:	8d 76 00             	lea    0x0(%esi),%esi
 3b4:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 3b8:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c2:	00 
 3c3:	89 74 24 04          	mov    %esi,0x4(%esp)
 3c7:	89 3c 24             	mov    %edi,(%esp)
 3ca:	e8 f0 fe ff ff       	call   2bf <write>
  while(--i >= 0)
 3cf:	4b                   	dec    %ebx
 3d0:	83 fb ff             	cmp    $0xffffffff,%ebx
 3d3:	75 df                	jne    3b4 <printint+0x4c>
    putc(fd, buf[i]);
}
 3d5:	83 c4 3c             	add    $0x3c,%esp
 3d8:	5b                   	pop    %ebx
 3d9:	5e                   	pop    %esi
 3da:	5f                   	pop    %edi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
    x = -xx;
 3dd:	f7 d8                	neg    %eax
    neg = 1;
 3df:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 3e4:	eb 9c                	jmp    382 <printint+0x1a>
 3e6:	66 90                	xchg   %ax,%ax

000003e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	57                   	push   %edi
 3ec:	56                   	push   %esi
 3ed:	53                   	push   %ebx
 3ee:	83 ec 3c             	sub    $0x3c,%esp
 3f1:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3f7:	8a 03                	mov    (%ebx),%al
 3f9:	84 c0                	test   %al,%al
 3fb:	0f 84 bb 00 00 00    	je     4bc <printf+0xd4>
printf(int fd, char *fmt, ...)
 401:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 402:	8d 55 10             	lea    0x10(%ebp),%edx
 405:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 408:	31 ff                	xor    %edi,%edi
 40a:	eb 2f                	jmp    43b <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 40c:	83 f9 25             	cmp    $0x25,%ecx
 40f:	0f 84 af 00 00 00    	je     4c4 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 415:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 418:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41f:	00 
 420:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 423:	89 44 24 04          	mov    %eax,0x4(%esp)
 427:	89 34 24             	mov    %esi,(%esp)
 42a:	e8 90 fe ff ff       	call   2bf <write>
 42f:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 430:	8a 43 ff             	mov    -0x1(%ebx),%al
 433:	84 c0                	test   %al,%al
 435:	0f 84 81 00 00 00    	je     4bc <printf+0xd4>
    c = fmt[i] & 0xff;
 43b:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 43e:	85 ff                	test   %edi,%edi
 440:	74 ca                	je     40c <printf+0x24>
      }
    } else if(state == '%'){
 442:	83 ff 25             	cmp    $0x25,%edi
 445:	75 e8                	jne    42f <printf+0x47>
      if(c == 'd'){
 447:	83 f9 64             	cmp    $0x64,%ecx
 44a:	0f 84 14 01 00 00    	je     564 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 450:	83 f9 78             	cmp    $0x78,%ecx
 453:	74 7b                	je     4d0 <printf+0xe8>
 455:	83 f9 70             	cmp    $0x70,%ecx
 458:	74 76                	je     4d0 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 45a:	83 f9 73             	cmp    $0x73,%ecx
 45d:	0f 84 91 00 00 00    	je     4f4 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 463:	83 f9 63             	cmp    $0x63,%ecx
 466:	0f 84 cc 00 00 00    	je     538 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 46c:	83 f9 25             	cmp    $0x25,%ecx
 46f:	0f 84 13 01 00 00    	je     588 <printf+0x1a0>
 475:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 480:	00 
 481:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 484:	89 44 24 04          	mov    %eax,0x4(%esp)
 488:	89 34 24             	mov    %esi,(%esp)
 48b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 48e:	e8 2c fe ff ff       	call   2bf <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 493:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 496:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 499:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a0:	00 
 4a1:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4a4:	89 54 24 04          	mov    %edx,0x4(%esp)
 4a8:	89 34 24             	mov    %esi,(%esp)
 4ab:	e8 0f fe ff ff       	call   2bf <write>
      }
      state = 0;
 4b0:	31 ff                	xor    %edi,%edi
 4b2:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 4b3:	8a 43 ff             	mov    -0x1(%ebx),%al
 4b6:	84 c0                	test   %al,%al
 4b8:	75 81                	jne    43b <printf+0x53>
 4ba:	66 90                	xchg   %ax,%ax
    }
  }
}
 4bc:	83 c4 3c             	add    $0x3c,%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5e                   	pop    %esi
 4c1:	5f                   	pop    %edi
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    
        state = '%';
 4c4:	bf 25 00 00 00       	mov    $0x25,%edi
 4c9:	e9 61 ff ff ff       	jmp    42f <printf+0x47>
 4ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4d7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4df:	8b 10                	mov    (%eax),%edx
 4e1:	89 f0                	mov    %esi,%eax
 4e3:	e8 80 fe ff ff       	call   368 <printint>
        ap++;
 4e8:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 4ec:	31 ff                	xor    %edi,%edi
        ap++;
 4ee:	e9 3c ff ff ff       	jmp    42f <printf+0x47>
 4f3:	90                   	nop
        s = (char*)*ap;
 4f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4f7:	8b 3a                	mov    (%edx),%edi
        ap++;
 4f9:	83 c2 04             	add    $0x4,%edx
 4fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 4ff:	85 ff                	test   %edi,%edi
 501:	0f 84 a3 00 00 00    	je     5aa <printf+0x1c2>
        while(*s != 0){
 507:	8a 07                	mov    (%edi),%al
 509:	84 c0                	test   %al,%al
 50b:	74 24                	je     531 <printf+0x149>
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 513:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51a:	00 
 51b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 51e:	89 44 24 04          	mov    %eax,0x4(%esp)
 522:	89 34 24             	mov    %esi,(%esp)
 525:	e8 95 fd ff ff       	call   2bf <write>
          s++;
 52a:	47                   	inc    %edi
        while(*s != 0){
 52b:	8a 07                	mov    (%edi),%al
 52d:	84 c0                	test   %al,%al
 52f:	75 df                	jne    510 <printf+0x128>
      state = 0;
 531:	31 ff                	xor    %edi,%edi
 533:	e9 f7 fe ff ff       	jmp    42f <printf+0x47>
        putc(fd, *ap);
 538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 53b:	8b 02                	mov    (%edx),%eax
 53d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 540:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 547:	00 
 548:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	89 34 24             	mov    %esi,(%esp)
 552:	e8 68 fd ff ff       	call   2bf <write>
        ap++;
 557:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 55b:	31 ff                	xor    %edi,%edi
 55d:	e9 cd fe ff ff       	jmp    42f <printf+0x47>
 562:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 564:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 56b:	b1 0a                	mov    $0xa,%cl
 56d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 570:	8b 10                	mov    (%eax),%edx
 572:	89 f0                	mov    %esi,%eax
 574:	e8 ef fd ff ff       	call   368 <printint>
        ap++;
 579:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 57d:	66 31 ff             	xor    %di,%di
 580:	e9 aa fe ff ff       	jmp    42f <printf+0x47>
 585:	8d 76 00             	lea    0x0(%esi),%esi
 588:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 58c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 593:	00 
 594:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	89 34 24             	mov    %esi,(%esp)
 59e:	e8 1c fd ff ff       	call   2bf <write>
      state = 0;
 5a3:	31 ff                	xor    %edi,%edi
 5a5:	e9 85 fe ff ff       	jmp    42f <printf+0x47>
          s = "(null)";
 5aa:	bf 7c 07 00 00       	mov    $0x77c,%edi
 5af:	e9 53 ff ff ff       	jmp    507 <printf+0x11f>

000005b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5bd:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c0:	a1 18 0a 00 00       	mov    0xa18,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c5:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c7:	39 d0                	cmp    %edx,%eax
 5c9:	72 11                	jb     5dc <free+0x28>
 5cb:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cc:	39 c8                	cmp    %ecx,%eax
 5ce:	72 04                	jb     5d4 <free+0x20>
 5d0:	39 ca                	cmp    %ecx,%edx
 5d2:	72 10                	jb     5e4 <free+0x30>
 5d4:	89 c8                	mov    %ecx,%eax
 5d6:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d8:	39 d0                	cmp    %edx,%eax
 5da:	73 f0                	jae    5cc <free+0x18>
 5dc:	39 ca                	cmp    %ecx,%edx
 5de:	72 04                	jb     5e4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	39 c8                	cmp    %ecx,%eax
 5e2:	72 f0                	jb     5d4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e7:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5ea:	39 cf                	cmp    %ecx,%edi
 5ec:	74 1a                	je     608 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ee:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f1:	8b 48 04             	mov    0x4(%eax),%ecx
 5f4:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5f7:	39 f2                	cmp    %esi,%edx
 5f9:	74 24                	je     61f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5fb:	89 10                	mov    %edx,(%eax)
  freep = p;
 5fd:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 602:	5b                   	pop    %ebx
 603:	5e                   	pop    %esi
 604:	5f                   	pop    %edi
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
 607:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 608:	03 71 04             	add    0x4(%ecx),%esi
 60b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 08                	mov    (%eax),%ecx
 610:	8b 09                	mov    (%ecx),%ecx
 612:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 48 04             	mov    0x4(%eax),%ecx
 618:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 61b:	39 f2                	cmp    %esi,%edx
 61d:	75 dc                	jne    5fb <free+0x47>
    p->s.size += bp->s.size;
 61f:	03 4b fc             	add    -0x4(%ebx),%ecx
 622:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 625:	8b 53 f8             	mov    -0x8(%ebx),%edx
 628:	89 10                	mov    %edx,(%eax)
  freep = p;
 62a:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 62f:	5b                   	pop    %ebx
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret    

00000634 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	56                   	push   %esi
 639:	53                   	push   %ebx
 63a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63d:	8b 75 08             	mov    0x8(%ebp),%esi
 640:	83 c6 07             	add    $0x7,%esi
 643:	c1 ee 03             	shr    $0x3,%esi
 646:	46                   	inc    %esi
  if((prevp = freep) == 0){
 647:	8b 15 18 0a 00 00    	mov    0xa18,%edx
 64d:	85 d2                	test   %edx,%edx
 64f:	0f 84 8d 00 00 00    	je     6e2 <malloc+0xae>
 655:	8b 02                	mov    (%edx),%eax
 657:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 65a:	39 ce                	cmp    %ecx,%esi
 65c:	76 52                	jbe    6b0 <malloc+0x7c>
 65e:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 665:	eb 0a                	jmp    671 <malloc+0x3d>
 667:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 668:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 66a:	8b 48 04             	mov    0x4(%eax),%ecx
 66d:	39 ce                	cmp    %ecx,%esi
 66f:	76 3f                	jbe    6b0 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 671:	89 c2                	mov    %eax,%edx
 673:	3b 05 18 0a 00 00    	cmp    0xa18,%eax
 679:	75 ed                	jne    668 <malloc+0x34>
  if(nu < 4096)
 67b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 681:	76 4d                	jbe    6d0 <malloc+0x9c>
 683:	89 d8                	mov    %ebx,%eax
 685:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 687:	89 04 24             	mov    %eax,(%esp)
 68a:	e8 a0 fc ff ff       	call   32f <sbrk>
  if(p == (char*)-1)
 68f:	83 f8 ff             	cmp    $0xffffffff,%eax
 692:	74 18                	je     6ac <malloc+0x78>
  hp->s.size = nu;
 694:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 697:	83 c0 08             	add    $0x8,%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 12 ff ff ff       	call   5b4 <free>
  return freep;
 6a2:	8b 15 18 0a 00 00    	mov    0xa18,%edx
      if((p = morecore(nunits)) == 0)
 6a8:	85 d2                	test   %edx,%edx
 6aa:	75 bc                	jne    668 <malloc+0x34>
        return 0;
 6ac:	31 c0                	xor    %eax,%eax
 6ae:	eb 18                	jmp    6c8 <malloc+0x94>
      if(p->s.size == nunits)
 6b0:	39 ce                	cmp    %ecx,%esi
 6b2:	74 28                	je     6dc <malloc+0xa8>
        p->s.size -= nunits;
 6b4:	29 f1                	sub    %esi,%ecx
 6b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6bc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6bf:	89 15 18 0a 00 00    	mov    %edx,0xa18
      return (void*)(p + 1);
 6c5:	83 c0 08             	add    $0x8,%eax
  }
}
 6c8:	83 c4 1c             	add    $0x1c,%esp
 6cb:	5b                   	pop    %ebx
 6cc:	5e                   	pop    %esi
 6cd:	5f                   	pop    %edi
 6ce:	5d                   	pop    %ebp
 6cf:	c3                   	ret    
  if(nu < 4096)
 6d0:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 6d5:	bf 00 10 00 00       	mov    $0x1000,%edi
 6da:	eb ab                	jmp    687 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 6dc:	8b 08                	mov    (%eax),%ecx
 6de:	89 0a                	mov    %ecx,(%edx)
 6e0:	eb dd                	jmp    6bf <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 6e2:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 6e9:	0a 00 00 
 6ec:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 6f3:	0a 00 00 
    base.s.size = 0;
 6f6:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 6fd:	00 00 00 
 700:	b8 1c 0a 00 00       	mov    $0xa1c,%eax
 705:	e9 54 ff ff ff       	jmp    65e <malloc+0x2a>
