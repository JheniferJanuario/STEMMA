using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Application.Cadastro.Tutores.Mappers;
using STEMMA.Domain.Cadastro.Repositories;

public class ListTutorsUseCase
{
    private readonly ITutorRepository _tutorRepository;

    public ListTutorsUseCase(
        ITutorRepository tutorRepository)
    {
        _tutorRepository = tutorRepository;
    }

    public async Task<List<TutorResponse>> ExecuteAsync()
    {
        var tutores = await _tutorRepository.ListarAsync();

        return TutorMapper.ToResponseList(tutores);
    }
}